//
//  DalleViewModel.swift
//  SwiftGPT
//
//  Created by mbabicz on 06/02/2023.
//

import Foundation
import OpenAIKit

class DalleViewModel: ObservableObject {
    private let apiKey: String
    private var openAI: OpenAI
    @Published var messages = [Message]()
    @Published var typingMessage: String = ""
    let bottomID = UUID()

    init() {
        apiKey = API.apiKey
        openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: apiKey))
    }
    
    func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        Task {
            let tempMessage = typingMessage.trimmingCharacters(in: .whitespaces)
            if !tempMessage.isEmpty {
                typingMessage = ""
                await generateImage(prompt: tempMessage)
            }
        }
    }
    
    func generateImage(prompt: String) async {
        self.addMessage(prompt, type: .text, isUserMessage: true)
        self.addMessage("", type: .indicator, isUserMessage: false)
        
        let imageParam = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)

        do {
            let result = try await openAI.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            let output = try openAI.decodeBase64Image(b64Image)
            self.addMessage(output, type: .image, isUserMessage: false)
        } catch {
            print(error)
            self.addMessage(error.localizedDescription, type: .error, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty just add new message
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, type: type, isUserMessage: isUserMessage)
                self.messages.append(message)
                return
            }
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            // if last message is an indicator switch with new one
            if lastMessage.type == .indicator && !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
            } else {
                // otherwise, add new message to the end of the list
                self.messages.append(message)
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
}
