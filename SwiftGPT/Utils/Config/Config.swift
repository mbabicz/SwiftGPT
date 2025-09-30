//
//  Config.swift
//  SwiftGPT
//
//  Application configuration constants
//

import Foundation

enum Config {
    // MARK: - Messages
    enum Messages {
        /// Maximum number of messages to keep in memory
        static let maxMessages = 100
    }

    // MARK: - DALL-E
    enum Dalle {
        /// Default image resolution for DALL-E generations
        /// Use .small (256x256), .medium (512x512), or .large (1024x1024)
        static let imageResolutionString = "512x512"

        /// Response format for DALL-E API
        /// Use "url" or "b64_json"
        static let responseFormatString = "b64_json"
    }

    // MARK: - User Interface
    enum UserInterface {
        /// Maximum lines for text input field
        static let textFieldMaxLines = 3

        /// Avatar icon size
        static let avatarSize: CGFloat = .appIconLG

        /// Input area corner radius
        static let inputCornerRadius: CGFloat = .appCornerRadiusMD

        /// Generated image corner radius
        static let imageCornerRadius: CGFloat = .appCornerRadiusLG
    }

    // MARK: - API
    enum API {
        /// OpenAI organization ID
        static let organizationId = "Personal"
    }
}
