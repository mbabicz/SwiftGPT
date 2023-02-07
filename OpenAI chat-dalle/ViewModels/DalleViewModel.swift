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
    
    func generateImage(prompt: String) async -> UIImage? {
        let imageParam = ImageParameters(prompt: prompt, resolution: .medium, responseFormat: .base64Json)
        
        do {
            let result = try await openAI.createImage(parameters: imageParam)
            let b64Image = result.data[0].image
            return try openAI.decodeBase64Image(b64Image)
        } catch {
            print(error)
            return nil
        }
    }
}
