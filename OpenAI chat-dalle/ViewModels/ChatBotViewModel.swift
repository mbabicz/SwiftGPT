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
        let filePath = Bundle.main.path(forResource: "Api-keys", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: filePath)!
        apiKey = plist["API_KEY"] as! String
        client = OpenAISwift(authToken: apiKey)
    }
    
    func getResponse(text: String) {
        
        self.addMessage(text, type: .text, isUserMessage: true)
        self.addMessage(text, type: .indicator, isUserMessage: false)

        client.sendCompletion(with: text, maxTokens: 500) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                self.removeLoadingIndicator()
                self.addMessage(output, type: .text, isUserMessage: false)
            case .failure(let error):
                self.removeLoadingIndicator()
                self.addMessage(error.localizedDescription, type: .text, isUserMessage: false)

            }
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            self.messages.append(message)
            print(self.messages)
        }
    }

    private func removeLoadingIndicator() {
        self.messages.removeLast()
    }
}
