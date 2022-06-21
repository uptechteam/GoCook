// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable function_parameter_count identifier_name line_length type_body_length
extension String {

  /// View all
  public static let homeCategoryViewAll = L10n.tr("Localizable", "home.category.view.all")

  /// Search...
  public static let homeSearchPlaceholder = L10n.tr("Localizable", "home.search.placeholder")

  /// My recipes
  public static let profileMyRecipes = L10n.tr("Localizable", "profile.my_recipes")

  /// Add new
  public static let profileButtonAddMoreTitle = L10n.tr("Localizable", "profile.button.add.more.title")

  /// You haven’t create any recipe yet\nLet’s chage it
  public static let profileEmptyContentTitle = L10n.tr("Localizable", "profile.empty.content.title")

  /// Add recipe
  public static let profileEmptyContentButtonTitle = L10n.tr("Localizable", "profile.empty.content.button.title")

  /// Sign in to create recipe
  public static let profileNotSignedInTitle = L10n.tr("Localizable", "profile.not.signed.in.title")

  /// Sign in
  public static let profileSignIn = L10n.tr("Localizable", "profile.sign.in")
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
