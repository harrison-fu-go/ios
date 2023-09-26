// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Home Page
  internal static let home = L10n.tr("Localizable", "home")
  /// User name
  internal static let userNameKey = L10n.tr("Localizable", "userNameKey")

  internal enum Development {
    /// init(coder:) has not been implemented
    internal static let fatalErrorInitCoderNotImplemented = L10n.tr("Localizable", "development.fatalErrorInitCoderNotImplemented")
    /// Subclass has to implement this function
    internal static let fatalErrorSubclassToImplement = L10n.tr("Localizable", "development.fatalErrorSubclassToImplement")
  }

  internal enum Guide {
    internal enum List {
      /// Loading Data Error
      internal static let error = L10n.tr("Localizable", "guide.list.error")
    }
  }

  internal enum InternalMenu {
    /// Avatars
    internal static let avatars = L10n.tr("Localizable", "internalMenu.avatars")
    /// CFBundleVersion
    internal static let cfBundleVersion = L10n.tr("Localizable", "internalMenu.CFBundleVersion")
    /// Colors
    internal static let colors = L10n.tr("Localizable", "internalMenu.colors")
    /// Crash App
    internal static let crashApp = L10n.tr("Localizable", "internalMenu.crashApp")
    /// Design Demo
    internal static let designDemo = L10n.tr("Localizable", "internalMenu.designDemo")
    /// Design Element
    internal static let designElement = L10n.tr("Localizable", "internalMenu.designElement")
    /// Favorite button
    internal static let favoriteButton = L10n.tr("Localizable", "internalMenu.favoriteButton")
    /// Feature Toggles
    internal static let featureToggles = L10n.tr("Localizable", "internalMenu.featureToggles")
    /// Hidden Features
    internal static let forbiddenArea = L10n.tr("Localizable", "internalMenu.forbiddenArea")
    /// General Info
    internal static let generalInfo = L10n.tr("Localizable", "internalMenu.generalInfo")
    /// Heart favorite button
    internal static let heartFavoriteButton = L10n.tr("Localizable", "internalMenu.heartFavoriteButton")
    /// Star favorite button
    internal static let starFavoriteButton = L10n.tr("Localizable", "internalMenu.starFavoriteButton")
    /// Test Button Enable
    internal static let testButtonEnabled = L10n.tr("Localizable", "internalMenu.testButtonEnabled")
    /// Tools
    internal static let tools = L10n.tr("Localizable", "internalMenu.tools")
    /// Typography
    internal static let typography = L10n.tr("Localizable", "internalMenu.typography")
    /// Version
    internal static let version = L10n.tr("Localizable", "internalMenu.version")
  }

  internal enum Mine {
    internal enum Title {
      /// App update
      internal static let appUpdate = L10n.tr("Localizable", "mine.title.appUpdate")
      /// Hardware update
      internal static let hardwareUpdate = L10n.tr("Localizable", "mine.title.hardwareUpdate")
      /// Operation introduce
      internal static let operationIntroduce = L10n.tr("Localizable", "mine.title.operationIntroduce")
      /// Wear control
      internal static let wearableControl = L10n.tr("Localizable", "mine.title.wearableControl")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
