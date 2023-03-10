//
//  ProfileStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import BusinessLogic
import DomainModels
import Helpers

extension ProfileViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var profile: Profile?
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case addNewRecipeTapped
        case editTapped
        case getFirstPage(Result<Void, Error>)
        case getNextPage(Result<Void, Error>)
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
        case settings
        case signIn
    }

    public struct Dependencies {

        // MARK: - Properties

        public let profileFacade: ProfileFacading
        public let profileRecipesFacade: ProfileRecipesFacading

        // MARK: - Lifecycle

        public init(profileFacade: ProfileFacading, profileRecipesFacade: ProfileRecipesFacading) {
            self.profileFacade = profileFacade
            self.profileRecipesFacade = profileRecipesFacade
        }
    }

    public static func makeStore(dependencies: Dependencies) -> Store {
        let getFirstPageMiddleware = makeGetFirstPageMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [getFirstPageMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            profile: nil,
            recipes: DomainModelState(),
            route: nil
        )
    }
}

extension ProfileViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .addNewRecipeTapped:
            newState.route = .init(value: .createRecipe)

        case .editTapped:
            newState.route = .init(value: .edit)

        case .getFirstPage(let result):
            newState.recipes.adjustState(accordingTo: result)

        case .getNextPage(let result):
            newState.recipes.adjustState(accordingTo: result)

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
