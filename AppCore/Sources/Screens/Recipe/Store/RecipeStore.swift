//
//  RecipeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import BusinessLogic
import DomainModels
import Foundation
import Helpers

extension RecipeViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        let recipe: Recipe
        var recipeDetails: DomainModelState<RecipeDetails>
        var route: AnyIdentifiable<Route>?

        var recipeName: String {
            recipeDetails.isPresent ? recipeDetails.name : recipe.name
        }

        var recipeImageSource: ImageSource {
            recipeDetails.isPresent ? recipeDetails.recipeImageSource : recipe.recipeImageSource
        }
    }

    public enum Action {
        case backTapped
        case getRecipeDetails(Result<RecipeDetails, Error>)
        case likeTapped
        case viewDidLoad
    }

    enum Route {
        case back
    }

    public struct Dependencies {

        // MARK: - Properties

        public let recipesClient: RecipesClienting

        // MARK: - Lifecycle

        public init(recipesClient: RecipesClienting) {
            self.recipesClient = recipesClient
        }
    }

    public static func makeStore(dependencies: Dependencies, envelope: RecipeEnvelope) -> Store {
        let getRecipeDetailsMiddleware = makeGetRecipeDetailsMiddleware(dependencies: dependencies)
        let likeMiddleware = makeLikeMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies, envelope: envelope),
            reducer: reduce,
            middlewares: [getRecipeDetailsMiddleware, likeMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies, envelope: RecipeEnvelope) -> State {
        return State(
            recipe: envelope.recipe,
            recipeDetails: DomainModelState(),
            route: nil
        )
    }
}

extension RecipeViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .likeTapped:
            break

        case .backTapped:
            newState.route = .init(value: .back)

        case .getRecipeDetails(let result):
            newState.recipeDetails.handle(result: result)

        case .viewDidLoad:
            newState.recipeDetails.toggleIsLoading(on: true)
        }

        return newState
    }
}
