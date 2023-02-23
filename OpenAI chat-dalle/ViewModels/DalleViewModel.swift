//
//  DalleViewModel.swift
//  OpenAI GPT-DALL-E
//
//  Created by kz on 06/02/2023.
//

import Foundation
import OpenAIKit
import UIKit

class DalleViewModel: ObservableObject {
    private let apiKey: String
    private var openAI: OpenAI
    @Published var messages = [Message]()

    init() {
        guard let filePath = Bundle.main.path(forResource: "Api-keys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist["API_KEY"] as? String
        else {
            fatalError("Couldn't find api key in Api-keys.plist")
        }
        apiKey = value
        openAI = OpenAI(Configuration(organizationId: "Personal", apiKey: apiKey))
    }
    
    func generateImage(prompt: String) async {
        self.addMessage(prompt, type: .text, isUserMessage: true)
        self.addMessage(prompt, type: .indicator, isUserMessage: false)
        
        let imageParam = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)

        do {
            let result = try await openAI.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            let output = try openAI.decodeBase64Image(b64Image)
            self.removeLoadingIndicator()
            self.addMessage(output, type: .image, isUserMessage: false)
        } catch {
            print(error)
            self.removeLoadingIndicator()
            self.addMessage(error.localizedDescription, type: .text, isUserMessage: false)
        }
    }
    
    private func addMessage(_ content: Any, type: MessageType, isUserMessage: Bool) {
        DispatchQueue.main.async {
            let message = Message(content: content, type: type, isUserMessage: isUserMessage)
            self.messages.append(message)
        }
    }

    private func removeLoadingIndicator() {
        DispatchQueue.main.async {
            self.messages.removeLast()
        }
    }
}
