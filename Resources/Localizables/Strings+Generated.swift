// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Accessibility {
    internal enum Button {
      /// Save image to photos
      internal static let save = L10n.tr("Localizable", "accessibility.button.save", fallback: "Save image to photos")
      /// Send message
      internal static let send = L10n.tr("Localizable", "accessibility.button.send", fallback: "Send message")
      /// Share image
      internal static let share = L10n.tr("Localizable", "accessibility.button.share", fallback: "Share image")
      internal enum Send {
        /// Sends your message to the AI
        internal static let hint = L10n.tr("Localizable", "accessibility.button.send.hint", fallback: "Sends your message to the AI")
      }
    }
    internal enum Image {
      /// Generated image
      internal static let generated = L10n.tr("Localizable", "accessibility.image.generated", fallback: "Generated image")
      /// AI avatar
      internal static let gpt = L10n.tr("Localizable", "accessibility.image.gpt", fallback: "AI avatar")
      /// User avatar
      internal static let user = L10n.tr("Localizable", "accessibility.image.user", fallback: "User avatar")
    }
    internal enum Tab {
      /// Chat with GPT
      internal static let chatgpt = L10n.tr("Localizable", "accessibility.tab.chatgpt", fallback: "Chat with GPT")
      /// Generate images with DALL·E
      internal static let dalle = L10n.tr("Localizable", "accessibility.tab.dalle", fallback: "Generate images with DALL·E")
    }
    internal enum Textfield {
      /// Message input field
      internal static let message = L10n.tr("Localizable", "accessibility.textfield.message", fallback: "Message input field")
    }
  }
  internal enum Chat {
    internal enum Introduce {
      /// Write your first message!
      internal static let title = L10n.tr("Localizable", "chat.introduce.title", fallback: "Write your first message!")
    }
  }
  internal enum Chatgpt {
    internal enum Tab {
      /// CHAT BOT
      internal static let title = L10n.tr("Localizable", "chatgpt.tab.title", fallback: "CHAT BOT")
    }
  }
  internal enum Dalle {
    internal enum Error {
      /// Image conversion error
      internal static let imageConversion = L10n.tr("Localizable", "dalle.error.image_conversion", fallback: "Image conversion error")
    }
    internal enum Tab {
      /// DALL·E 2
      internal static let title = L10n.tr("Localizable", "dalle.tab.title", fallback: "DALL·E 2")
    }
  }
  internal enum Error {
    /// API request failed
    internal static let api = L10n.tr("Localizable", "error.api", fallback: "API request failed")
    /// Network error occurred
    internal static let network = L10n.tr("Localizable", "error.network", fallback: "Network error occurred")
    /// Failed to save image to Photos
    internal static let savePhoto = L10n.tr("Localizable", "error.save_photo", fallback: "Failed to save image to Photos")
    /// Permission denied. Please allow access to Photos in Settings.
    internal static let savePhotoPermission = L10n.tr("Localizable", "error.save_photo_permission", fallback: "Permission denied. Please allow access to Photos in Settings.")
    /// An unexpected error occurred
    internal static let unknown = L10n.tr("Localizable", "error.unknown", fallback: "An unexpected error occurred")
  }
  internal enum Message {
    internal enum Textfield {
      /// Message...
      internal static let placeholder = L10n.tr("Localizable", "message.textfield.placeholder", fallback: "Message...")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
