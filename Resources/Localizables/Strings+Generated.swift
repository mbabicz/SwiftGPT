// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
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
    internal enum Tab {
      /// DALL·E 2
      internal static let title = L10n.tr("Localizable", "dalle.tab.title", fallback: "DALL·E 2")
    }
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
