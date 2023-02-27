//
//  OpenAIViewModel.swift
//  OpenAI chat-dalle
//
//  Created by kz on 27/02/2023.
//

import Foundation
import OpenAIKit
import OpenAISwift

class OpenAIViewModel: ObservableObject {
    
    private let apiKey: String
    private var dalleClient: OpenAIKit.OpenAI
    private let gptClient: OpenAISwift
    
    @Published var dalleMessages = [Message]()
    @Published var gptMessages = [Message]()
    
    init() {

        apiKey = "API_KEY"
        dalleClient = OpenAI(Configuration(organizationId: "Personal", apiKey: apiKey))
        gptClient = OpenAISwift(authToken: apiKey)
    }
    
    func generateDalleImage(prompt: String) async {
        self.addMessage(prompt, type: .text, isUserMessage: true, messages: &dalleMessages)
        self.addMessage(prompt, type: .indicator, isUserMessage: false, messages: &dalleMessages)
        
        let imageParam = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)
        
        do {
            let result = try await dalleClient.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            let output = try dalleClient.decodeBase64Image(b64Image)
            self.addMessage(output, type: .image, isUserMessage: false, messages: &dalleMessages)
        } catch {
            print(error)
            self.addMessage(error.localizedDescription, type: .text, isUserMessage: false, messages: &dalleMessages)
        }
    }
    
    func getGPTResponse(text: String) {
        addMessage(text, type: .text, isUserMessage: true, messages: &gptMessages)
        addMessage(text, type: .indicator, isUserMessage: false, messages: &gptMessages)

        gptClient.sendCompletion(with: text, maxTokens: 500) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                self.addMessage(output, type: .text, isUserMessage: false, messages: &self.gptMessages)

            case .failure(let error):
              self.addMessage(error.localizedDescription, type: .text, isUserMessage: false, messages: &self.gptMessages)
            }
        }
    }

    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool, messages: inout [Message]) {
        DispatchQueue.main.async {
            // if messages list is empty just add new message
            guard let lastMessage = messages.last else {
                let message = Message(content: content, type: type, isUserMessage: isUserMessage)
                messages.append(message)
                return
            }

            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            // if last message is an indicator switch with new one
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                messages[messages.count - 1] = message
            } else {
                // otherwise, add new message to the end of the list
                messages.append(message)
            }
        }
    }

}
