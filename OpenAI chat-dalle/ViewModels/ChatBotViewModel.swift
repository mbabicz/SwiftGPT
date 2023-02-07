//
//  ChatBotViewModel.swift
//  ChattingAPP
//
//  Created by kz on 26/01/2023.
//

import Foundation
import OpenAISwift

class ChatBotViewModel: ObservableObject {
    var isWaitingForResponse: Bool = false
    private let apiKey: String
    private let client: OpenAISwift

    init() {
        let filePath = Bundle.main.path(forResource: "Api-keys", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: filePath)!
        apiKey = plist["API_KEY"] as! String
        client = OpenAISwift(authToken: apiKey)
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        self.isWaitingForResponse = true
        
        client.sendCompletion(with: text, maxTokens: 500) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
                self.isWaitingForResponse = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
