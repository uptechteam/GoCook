// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// MARK: - Strings

extension String {

  /// Got invalid data from server
  public static let apiErrorBrokenData = L10n.tr("Localizable", "api.error.broken.data")

  /// Can't reach the server
  public static let apiErrorConnotConnectToServer = L10n.tr("Localizable", "api.error.connot.connect.to.server")

  /// Unknown error occured
  public static let apiErrorUnknownError = L10n.tr("Localizable", "api.error.unknown.error")

  /// Recipes
  public static let authorRecipesTitle = L10n.tr("Localizable", "author.recipes.title")

  /// This author has no recipes yet
  public static let authorRecipesEmptyText = L10n.tr("Localizable", "author.recipes.empty.text")

  /// No reviews yet:
  public static let authorRecipesNoReviews = L10n.tr("Localizable", "author.recipes.no.reviews")

  /// Create recipe
  public static let createRecipeTitle = L10n.tr("Localizable", "create.recipe.title")

  /// Cancel
  public static let createRecipeAlertDeleteProgressCancel = L10n.tr("Localizable", "create.recipe.alert.delete.progress.cancel")

  /// Delete
  public static let createRecipeAlertDeleteProgressDelete = L10n.tr("Localizable", "create.recipe.alert.delete.progress.delete")

  /// Closing this page will delete the progress you’ve made in recipe creation
  public static let createRecipeAlertDeleteProgressMessage = L10n.tr("Localizable", "create.recipe.alert.delete.progress.message")

  /// Delete progress?
  public static let createRecipeAlertDeleteProgressTitle = L10n.tr("Localizable", "create.recipe.alert.delete.progress.title")

  /// Back
  public static let createRecipeNavigationBack = L10n.tr("Localizable", "create.recipe.navigation.back")

  /// Finish
  public static let createRecipeNavigationFinish = L10n.tr("Localizable", "create.recipe.navigation.finish")

  /// Next
  public static let createRecipeNavigationNext = L10n.tr("Localizable", "create.recipe.navigation.next")

  /// %d / 4
  public static func createRecipeNavigationTitle(_ p1: Int) -> String {
    return L10n.tr("Localizable", "create.recipe.navigation.title", p1)
  }

  /// Category
  public static let createRecipeStepOneCategoryTitle = L10n.tr("Localizable", "create.recipe.step.one.category.title")

  /// Select meal category
  public static let createRecipeStepOneCategoryValidation = L10n.tr("Localizable", "create.recipe.step.one.category.validation")

  /// MEAL NAME
  public static let createRecipeStepOneMealTitle = L10n.tr("Localizable", "create.recipe.step.one.meal.title")

  /// Enter meal name
  public static let createRecipeStepOneMealValidation = L10n.tr("Localizable", "create.recipe.step.one.meal.validation")

  /// Upload meal photo
  public static let createRecipeStepOnePhotoValidation = L10n.tr("Localizable", "create.recipe.step.one.photo.validation")

  /// Uploading unsuccessfull. Please retry
  public static let createRecipeStepOneUploadError = L10n.tr("Localizable", "create.recipe.step.one.upload.error")

  /// Add step
  public static let createRecipeStepThreeAddStep = L10n.tr("Localizable", "create.recipe.step.three.add.step")

  /// Instructions
  public static let createRecipeStepThreeInstructionsTitle = L10n.tr("Localizable", "create.recipe.step.three.instructions.title")

  /// STEP %d
  public static func createRecipeStepThreeStepTitle(_ p1: Int) -> String {
    return L10n.tr("Localizable", "create.recipe.step.three.step.title", p1)
  }

  /// Enter step %d
  public static func createRecipeStepThreeStepValidation(_ p1: Int) -> String {
    return L10n.tr("Localizable", "create.recipe.step.three.step.validation", p1)
  }

  /// Enter amount
  public static let createRecipeStepThreeTimePlaceholder = L10n.tr("Localizable", "create.recipe.step.three.time.placeholder")

  /// %d min
  public static func createRecipeStepThreeTimeText(_ p1: Int) -> String {
    return L10n.tr("Localizable", "create.recipe.step.three.time.text", p1)
  }

  /// Cooking time, min
  public static let createRecipeStepThreeTimeTitle = L10n.tr("Localizable", "create.recipe.step.three.time.title")

  /// Add ingredient
  public static let createRecipeStepTwoAddIngredient = L10n.tr("Localizable", "create.recipe.step.two.add.ingredient")

  /// Enter amount
  public static let createRecipeStepTwoIngredientsAmount = L10n.tr("Localizable", "create.recipe.step.two.ingredients.amount")

  /// Enter name
  public static let createRecipeStepTwoIngredientsName = L10n.tr("Localizable", "create.recipe.step.two.ingredients.name")

  /// Ingredients
  public static let createRecipeStepTwoIngredientsTitle = L10n.tr("Localizable", "create.recipe.step.two.ingredients.title")

  /// Enter amount
  public static let createRecipeStepTwoServingsPlaceholder = L10n.tr("Localizable", "create.recipe.step.two.servings.placeholder")

  /// Number of servings
  public static let createRecipeStepTwoServingsTitle = L10n.tr("Localizable", "create.recipe.step.two.servings.title")

  /// Submit
  public static let editProfileSubmit = L10n.tr("Localizable", "edit.profile.submit")

  /// Edit Profile
  public static let editProfileTitle = L10n.tr("Localizable", "edit.profile.title")

  /// USERNAME
  public static let editProfileInputTitle = L10n.tr("Localizable", "edit.profile.input.title")

  /// Favorites
  public static let favoritesTitle = L10n.tr("Localizable", "favorites.title")

  ///  and 
  public static let favoritesCategoriesJoinText = L10n.tr("Localizable", "favorites.categories.join.text")

  /// 15 - 30 mins
  public static let favoritesCookingTimeFifteenToThirty = L10n.tr("Localizable", "favorites.cooking.time.fifteen.to.thirty")

  /// 5 - 15 mins
  public static let favoritesCookingTimeFiveToFifteen = L10n.tr("Localizable", "favorites.cooking.time.five.to.fifteen")

  /// 45+ mins
  public static let favoritesCookingTimeMoreThanFortyFive = L10n.tr("Localizable", "favorites.cooking.time.more.than.forty.five")

  /// 30 - 45 mins
  public static let favoritesCookingTimeThirtyToFortyFive = L10n.tr("Localizable", "favorites.cooking.time.thirty.to.forty.five")

  /// Explore
  public static let favoritesEmptyButton = L10n.tr("Localizable", "favorites.empty.button")

  /// You have no favorited\nrecipes yet
  public static let favoritesEmptyTitle = L10n.tr("Localizable", "favorites.empty.title")

  /// Retry
  public static let favoritesErrorButton = L10n.tr("Localizable", "favorites.error.button")

  /// Something went bad
  public static let favoritesErrorTitle = L10n.tr("Localizable", "favorites.error.title")

  /// You’re looking for recipes
  public static let favoritesFilterDescription = L10n.tr("Localizable", "favorites.filter.description")

  ///  in %@ categories
  public static func favoritesFilterDescriptionCategories(_ p1: String) -> String {
    return L10n.tr("Localizable", "favorites.filter.description.categories", p1)
  }

  ///  with %@ cooking time
  public static func favoritesFilterDescriptionCookingTime(_ p1: String) -> String {
    return L10n.tr("Localizable", "favorites.filter.description.cooking.time", p1)
  }

  /// Open filters
  public static let favoritesFilteredEmptyButton = L10n.tr("Localizable", "favorites.filtered.empty.button")

  /// No recipes found\nAdjust the filters and try again
  public static let favoritesFilteredEmptyTitle = L10n.tr("Localizable", "favorites.filtered.empty.title")

  /// No results found
  public static let favoritesNoResultsTitle = L10n.tr("Localizable", "favorites.no.results.title")

  /// Search...
  public static let favoritesSearchPlaceholder = L10n.tr("Localizable", "favorites.search.placeholder")

  /// , 
  public static let favoritesTimeFiltersJoinText = L10n.tr("Localizable", "favorites.time.filters.join.text")

  /// Apply
  public static let filtersApply = L10n.tr("Localizable", "filters.apply")

  /// Filters
  public static let filtersTitle = L10n.tr("Localizable", "filters.title")

  /// Clear all
  public static let filtersClearAll = L10n.tr("Localizable", "filters.clear.all")

  /// Category
  public static let filtersSectionCategory = L10n.tr("Localizable", "filters.section.category")

  /// Cooling time
  public static let filtersSectionCookingTime = L10n.tr("Localizable", "filters.section.cooking.time")

  /// 15 - 30 mins
  public static let filtersSectionCookingTimeFifteenToThirty = L10n.tr("Localizable", "filters.section.cooking.time.fifteen.to.thirty")

  /// 5 - 15 mins
  public static let filtersSectionCookingTimeFiveToFifteen = L10n.tr("Localizable", "filters.section.cooking.time.five.to.fifteen")

  /// 45+ mins
  public static let filtersSectionCookingTimeMoreThanFortyFive = L10n.tr("Localizable", "filters.section.cooking.time.more.than.forty.five")

  /// 30 - 45 mins
  public static let filtersSectionCookingTimeThirtyToFortyFive = L10n.tr("Localizable", "filters.section.cooking.time.thirty.to.forty.five")

  ///  and 
  public static let homeCategoriesJoinText = L10n.tr("Localizable", "home.categories.join.text")

  /// View all
  public static let homeCategoryViewAll = L10n.tr("Localizable", "home.category.view.all")

  /// 15 - 30 mins
  public static let homeCookingTimeFifteenToThirty = L10n.tr("Localizable", "home.cooking.time.fifteen.to.thirty")

  /// 5 - 15 mins
  public static let homeCookingTimeFiveToFifteen = L10n.tr("Localizable", "home.cooking.time.five.to.fifteen")

  /// 45+ mins
  public static let homeCookingTimeMoreThanFortyFive = L10n.tr("Localizable", "home.cooking.time.more.than.forty.five")

  /// 30 - 45 mins
  public static let homeCookingTimeThirtyToFortyFive = L10n.tr("Localizable", "home.cooking.time.thirty.to.forty.five")

  /// You’re looking for recipes
  public static let homeFilterDescription = L10n.tr("Localizable", "home.filter.description")

  ///  in %@ categories
  public static func homeFilterDescriptionCategories(_ p1: String) -> String {
    return L10n.tr("Localizable", "home.filter.description.categories", p1)
  }

  ///  with %@ cooking time
  public static func homeFilterDescriptionCookingTime(_ p1: String) -> String {
    return L10n.tr("Localizable", "home.filter.description.cooking.time", p1)
  }

  /// Open filters
  public static let homeFilteredEmptyButton = L10n.tr("Localizable", "home.filtered.empty.button")

  /// No recipes found\nAdjust the filters and try again
  public static let homeFilteredEmptyTitle = L10n.tr("Localizable", "home.filtered.empty.title")

  /// No results found
  public static let homeNoResultsTitle = L10n.tr("Localizable", "home.no.results.title")

  /// Search...
  public static let homeSearchPlaceholder = L10n.tr("Localizable", "home.search.placeholder")

  /// , 
  public static let homeTimeFiltersJoinText = L10n.tr("Localizable", "home.time.filters.join.text")

  /// Take photo
  public static let imagePickerCamera = L10n.tr("Localizable", "image.picker.camera")

  /// Cancel
  public static let imagePickerCancel = L10n.tr("Localizable", "image.picker.cancel")

  /// Chose from library
  public static let imagePickerLibrary = L10n.tr("Localizable", "image.picker.library")

  /// Remove current photo
  public static let imagePickerRemove = L10n.tr("Localizable", "image.picker.remove")

  /// cup
  public static let ingredientUnitCupReduction = L10n.tr("Localizable", "ingredient.unit.cup.reduction")

  /// g
  public static let ingredientUnitGramReduction = L10n.tr("Localizable", "ingredient.unit.gram.reduction")

  /// kg
  public static let ingredientUnitKilogramReduction = L10n.tr("Localizable", "ingredient.unit.kilogram.reduction")

  /// liter
  public static let ingredientUnitLiterReduction = L10n.tr("Localizable", "ingredient.unit.liter.reduction")

  /// ml
  public static let ingredientUnitMilliliterReduction = L10n.tr("Localizable", "ingredient.unit.milliliter.reduction")

  /// pinch
  public static let ingredientUnitPinchReduction = L10n.tr("Localizable", "ingredient.unit.pinch.reduction")

  /// tbsp
  public static let ingredientUnitTableSpoonReduction = L10n.tr("Localizable", "ingredient.unit.table.spoon.reduction")

  /// tsp
  public static let ingredientUnitTeaSpoonReduction = L10n.tr("Localizable", "ingredient.unit.tea.spoon.reduction")

  /// whole
  public static let ingredientUnitWholeReduction = L10n.tr("Localizable", "ingredient.unit.whole.reduction")

  /// Amount
  public static let inputAmountPlaceholder = L10n.tr("Localizable", "input.amount.placeholder")

  /// Ingredient amount
  public static let inputAmountTitle = L10n.tr("Localizable", "input.amount.title")

  /// Save
  public static let inputButtonTitle = L10n.tr("Localizable", "input.button.title")

  /// Name
  public static let inputIngredientPlaceholder = L10n.tr("Localizable", "input.ingredient.placeholder")

  /// Ingredient name
  public static let inputIngredientTitle = L10n.tr("Localizable", "input.ingredient.title")

  /// Amount
  public static let inputServingsPlaceholder = L10n.tr("Localizable", "input.servings.placeholder")

  /// Number of servings
  public static let inputServingsTitle = L10n.tr("Localizable", "input.servings.title")

  /// Amount
  public static let inputTimePlaceholder = L10n.tr("Localizable", "input.time.placeholder")

  /// Cooking time, min
  public static let inputTimeTitle = L10n.tr("Localizable", "input.time.title")

  /// Login
  public static let loginLogin = L10n.tr("Localizable", "login.login")

  /// OR
  public static let loginOr = L10n.tr("Localizable", "login.or")

  /// Skip
  public static let loginSkip = L10n.tr("Localizable", "login.skip")

  /// Sign in
  public static let loginTitle = L10n.tr("Localizable", "login.title")

  /// Login with Apple
  public static let loginLoginWithApple = L10n.tr("Localizable", "login.login.with.apple")

  /// USERNAME
  public static let loginNameTitle = L10n.tr("Localizable", "login.name.title")

  /// New to GoCook? 
  public static let loginNewFirst = L10n.tr("Localizable", "login.new.first")

  /// Sign up
  public static let loginNewSecond = L10n.tr("Localizable", "login.new.second")

  /// PASSWORD
  public static let loginPasswordTitle = L10n.tr("Localizable", "login.password.title")

  /// Log into GoCook
  public static let loginTextTitleProfile = L10n.tr("Localizable", "login.text.title.profile")

  /// Log into\nGoCook
  public static let loginTextTitleRegistration = L10n.tr("Localizable", "login.text.title.registration")

  /// Add new
  public static let profileButtonAddMoreTitle = L10n.tr("Localizable", "profile.button.add.more.title")

  /// You haven’t create any recipe yet\nLet’s chage it
  public static let profileEmptyContentTitle = L10n.tr("Localizable", "profile.empty.content.title")

  /// Add recipe
  public static let profileEmptyContentButtonTitle = L10n.tr("Localizable", "profile.empty.content.button.title")

  /// My recipes
  public static let profileMyRecipes = L10n.tr("Localizable", "profile.my.recipes")

  /// Sign in to create recipe
  public static let profileNotSignedInTitle = L10n.tr("Localizable", "profile.not.signed.in.title")

  /// Sign in
  public static let profileSignIn = L10n.tr("Localizable", "profile.sign.in")

  /// Delete
  public static let recipeDelete = L10n.tr("Localizable", "recipe.delete")

  /// Edit
  public static let recipeEdit = L10n.tr("Localizable", "recipe.edit")

  /// Share
  public static let recipeShare = L10n.tr("Localizable", "recipe.share")

  /// (%d reviews)
  public static func recipeDetailsReviews(_ p1: Int) -> String {
    return L10n.tr("Localizable", "recipe.details.reviews", p1)
  }

  /// %d min
  public static func recipeDetailsCookingTime(_ p1: Int) -> String {
    return L10n.tr("Localizable", "recipe.details.cooking.time", p1)
  }

  /// (1 review)
  public static let recipeDetailsOneReview = L10n.tr("Localizable", "recipe.details.one.review")

  /// Retry
  public static let recipeErrorRetry = L10n.tr("Localizable", "recipe.error.retry")

  /// Something went wrong\nPlease try again
  public static let recipeErrorTitle = L10n.tr("Localizable", "recipe.error.title")

  /// %d servings
  public static func recipeIngredientsServings(_ p1: Int) -> String {
    return L10n.tr("Localizable", "recipe.ingredients.servings", p1)
  }

  /// Ingredients
  public static let recipeIngredientsTitle = L10n.tr("Localizable", "recipe.ingredients.title")

  /// 1 serving
  public static let recipeIngredientsOneServing = L10n.tr("Localizable", "recipe.ingredients.one.serving")

  /// Instructions
  public static let recipeInstructionsTitle = L10n.tr("Localizable", "recipe.instructions.title")

  /// %d Step
  public static func recipeInstructionsStepTitle(_ p1: Int) -> String {
    return L10n.tr("Localizable", "recipe.instructions.step.title", p1)
  }

  /// How would you rate %@?
  public static func recipeRatingQuestion(_ p1: String) -> String {
    return L10n.tr("Localizable", "recipe.rating.question", p1)
  }

  /// Thank you for your feedback!
  public static let recipeRatingThankYou = L10n.tr("Localizable", "recipe.rating.thank.you")

  /// Log out
  public static let settingsLogout = L10n.tr("Localizable", "settings.logout")

  /// Settings
  public static let settingsTitle = L10n.tr("Localizable", "settings.title")

  /// OR
  public static let signUpOr = L10n.tr("Localizable", "sign.up.or")

  /// Skip
  public static let signUpSkip = L10n.tr("Localizable", "sign.up.skip")

  /// Find your\ntasty idea\nwith GoCook
  public static let signUpTitle = L10n.tr("Localizable", "sign.up.title")

  /// Already have an account? 
  public static let signUpHaveAnAccountFirst = L10n.tr("Localizable", "sign.up.have.an.account.first")

  /// Login
  public static let signUpHaveAnAccountSecond = L10n.tr("Localizable", "sign.up.have.an.account.second")

  /// USERNAME
  public static let signUpNameTitle = L10n.tr("Localizable", "sign.up.name.title")

  /// Password must be at least 8 characters, contain uppercase and lowercase and numbers
  public static let signUpPasswordDescription = L10n.tr("Localizable", "sign.up.password.description")

  /// PASSWORD
  public static let signUpPasswordTitle = L10n.tr("Localizable", "sign.up.password.title")

  /// Sign up
  public static let signUpSignUp = L10n.tr("Localizable", "sign.up.sign.up")

  /// Sign up with Apple
  public static let signUpSignUpWithApple = L10n.tr("Localizable", "sign.up.sign.up.with.apple")

  /// Sign up to GoCook
  public static let signUpTextTitleProfile = L10n.tr("Localizable", "sign.up.text.title.profile")

  /// Find your\ntasty idea\nwith GoCook
  public static let signUpTextTitleRegistration = L10n.tr("Localizable", "sign.up.text.title.registration")

  /// Username should contain between 2 and 20 characters
  public static let validationNameLength = L10n.tr("Localizable", "validation.name.length")

  /// This username is taken. Try another one
  public static let validationNotUniqueUsername = L10n.tr("Localizable", "validation.not.unique.username")
}

// MARK: - Implementation Details

fileprivate final class L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
// swiftlint:enable all
