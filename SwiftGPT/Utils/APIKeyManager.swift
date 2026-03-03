//
//  APIKeyManager.swift
//  SwiftGPT
//
//  Manages user-provided API keys stored in UserDefaults.
//

import Foundation

final class APIKeyManager: ObservableObject {
    static let shared = APIKeyManager()

    private let claudeKeyUD = "claude_api_key"
    private let openaiKeyUD = "openai_api_key"

    @Published var claudeApiKey: String {
        didSet { UserDefaults.standard.set(claudeApiKey, forKey: claudeKeyUD) }
    }

    @Published var openaiApiKey: String {
        didSet { UserDefaults.standard.set(openaiApiKey, forKey: openaiKeyUD) }
    }

    var hasClaudeKey: Bool { !claudeApiKey.isEmpty }
    var hasOpenAIKey: Bool { !openaiApiKey.isEmpty }

    private init() {
        claudeApiKey = UserDefaults.standard.string(forKey: "claude_api_key") ?? ""
        openaiApiKey = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
    }
}
