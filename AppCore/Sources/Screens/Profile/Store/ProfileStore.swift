//
//  ProfileStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import BusinessLogic
import DomainModels
import Foundation
import Helpers

extension ProfileViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var pendingRecipe: Recipe?
        var profile: Profile?
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case addNewRecipeTapped
        case changeIsFavorite(Result<Void, Error>)
        case editTapped
        case favoriteTapped(IndexPath)
        case getPage(Result<Void, Error>)
        case recipeTapped(IndexPath)
        case scrolledToEnd
        case scrolledToRefresh
        case settingsTapped
        case signInTapped
        case updateProfile(Profile?)
        case updateRecipes([Recipe])
        case viewDidLoad
    }

    enum Route {
        case createRecipe
        case edit
        case recipe(Recipe)
        case settings
        case signIn
    }

    public struct Dependencies {

        // MARK: - Properties

        public let profileFacade: ProfileFacading
        public let profileRecipesFacade: ProfileRecipesFacading
        public let recipesFacade: RecipesFacading

        // MARK: - Lifecycle

        public init(
            profileFacade: ProfileFacading,
            profileRecipesFacade: ProfileRecipesFacading,
            recipesFacade: RecipesFacading
        ) {
            self.profileFacade = profileFacade
            self.profileRecipesFacade = profileRecipesFacade
            self.recipesFacade = recipesFacade
        }
    }

    public static func makeStore(dependencies: Dependencies) -> Store {
        let changeIsFavoriteMiddleware = makeChangeIsFavoriteMiddleware(dependencies: dependencies)
        let getFirstPageMiddleware = makeGetFirstPageMiddleware(dependencies: dependencies)
        let getNextPageMiddleware = makeGetNextPageMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [changeIsFavoriteMiddleware, getFirstPageMiddleware, getNextPageMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            pendingRecipe: nil,
            profile: nil,
            recipes: DomainModelState(),
            route: nil
        )
    }
}

extension ProfileViewController {
    // swiftlint:disable:next cyclomatic_complexity
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .addNewRecipeTapped:
            newState.route = .init(value: .createRecipe)

        case .changeIsFavorite:
            newState.pendingRecipe = nil

        case .editTapped:
            newState.route = .init(value: .edit)

        case .favoriteTapped(let indexPath):
            guard let recipe = newState.recipes.items[safe: indexPath.item], newState.pendingRecipe == nil else {
                break
            }

            newState.pendingRecipe = recipe

        case .getPage(let result):
            newState.recipes.adjustState(accordingTo: result)

        case .recipeTapped(let indexPath):
            guard let recipe = newState.recipes[safe: indexPath.item] else {
                break
            }

            newState.route = .init(value: .recipe(recipe))

        case .scrolledToEnd:
            break

        case .scrolledToRefresh:
            newState.recipes.toggleIsLoading(on: true)

        case .settingsTapped:
            newState.route = .init(value: .settings)

        case .signInTapped:
            newState.route = .init(value: .signIn)

        case .updateProfile(let profile):
            newState.profile = profile

        case .updateRecipes(let recipes):
            newState.recipes.update(with: recipes)

        case .viewDidLoad:
            newState.recipes.toggleIsLoading(on: true)
        }

        return newState
    }
}
