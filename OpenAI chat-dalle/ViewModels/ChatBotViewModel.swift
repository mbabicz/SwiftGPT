//
//  ChatBotViewModel.swift
//  ChattingAPP
//
//  Created by kz on 26/01/2023.
//

import Foundation
import OpenAISwift

class ChatBotViewModel: ObservableObject {
    private let apiKey: String
    private let client: OpenAISwift
    @Published var messages = [Message]()
    
    init() {
        apiKey = "API_KEY"
        client = OpenAISwift(authToken: apiKey)
    }
    
    func getResponse(text: String) {
        
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage("", type: .indicator, isUserMessage: false)

        client.sendCompletion(with: text, maxTokens: 500) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                guard let output = model.choices.first?.text else {
                    self.addMessage("Unexpected error", type: .text, isUserMessage: false)
                    return
                }
                self.addMessage(output, type: .text, isUserMessage: false)
            case .failure(let error):
                self.addMessage(error.localizedDescription, type: .text, isUserMessage: false)
            }
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
