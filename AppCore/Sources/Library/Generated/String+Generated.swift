// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
extension String {

  /// Feed
  public static let feedTitle = L10n.tr("Localizable", "feed.title")

  /// View all
  public static let feedCategoryViewAll = L10n.tr("Localizable", "feed.category.view.all")

  /// Search...
  public static let feedSearchPlaceholder = L10n.tr("Localizable", "feed.search.placeholder")
}
// swiftlint:enable function_parameter_count identifier_name line_length type_body_length

// MARK: - Implementation Details

fileprivate final class L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:enable convenience_type
