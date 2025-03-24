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
        self.addMessage(.text(prompt), isUserMessage: true)
        self.addMessage(.indicator, isUserMessage: false)
        
        let imageParam = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)
        
        do {
            let result = try await openAI.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            let output = try openAI.decodeBase64Image(b64Image)
            if let imageData = output.pngData() {
                self.addMessage(.image(imageData), isUserMessage: false)
            } else {
                self.addMessage(.error("Image conversion error"), isUserMessage: false)
            }
        } catch {
            debugPrint(error)
            self.addMessage(.error(error.localizedDescription), isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: MessageContent, isUserMessage: Bool) {
        DispatchQueue.main.async {
            // if messages list is empty just add new message
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, isUserMessage: isUserMessage)
                self.messages.append(message)
                return
            }
            let message = Message(content: content, isUserMessage: isUserMessage)

            // if last message is an indicator switch with new one
            if case .indicator = lastMessage.content, !lastMessage.isUserMessage {
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
