//
//  GPTViewModel.swift
//  SwiftGPT
//
//  Created by mbabicz on 05/03/2023.
//

import Foundation
import ChatGPTSwift

class GPTViewModel: ObservableObject {

    private let api: ChatGPTAPI
    @Published var messages: [Message] = []
    @Published var typingMessage: String = ""
    let bottomID = UUID()

    init(apiKey: String = API.apiKey) {
        self.api = ChatGPTAPI(apiKey: apiKey)
    }
    
    func sendMessage() {
        guard !typingMessage.isEmpty else { return }
        let tempMessage = typingMessage
        typingMessage = ""
        Task{
            await getResponse(text: tempMessage)
        }
    }
    
    private func addMessage(_ content: MessageContent, isUserMessage: Bool) {
        DispatchQueue.main.async {
            /// if messages list is empty just add new message
            guard let lastMessage = self.messages.last else {
                let message = Message(content: content, isUserMessage: isUserMessage)
                self.messages.append(message)
                return
            }
            let message = Message(content: content, isUserMessage: isUserMessage)
            
            /// if last message is an indicator switch with new one
            if case .indicator = lastMessage.content, !lastMessage.isUserMessage {
                self.messages[self.messages.count - 1] = message
            } else {
                /// otherwise, add new message to the end of the list
                self.messages.append(message)
            }
            
            if self.messages.count > 100 {
                self.messages.removeFirst()
            }
        }
    }
    
    func getResponse(text: String) async{
        
        self.addMessage(.text(text), isUserMessage: true)
        self.addMessage(.indicator, isUserMessage: false)

        do {
            let stream = try await api.sendMessageStream(text: text)

            for try await line in stream {
                DispatchQueue.main.async {
                    if case .text(let currentText) = self.messages[self.messages.count - 1].content {
                        self.messages[self.messages.count - 1].content = .text(currentText + line)
                    }
                }
            }
        } catch {
            self.addMessage(.error(error.localizedDescription), isUserMessage: false)
        }
    }
}
