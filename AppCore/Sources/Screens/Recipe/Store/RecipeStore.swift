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
        case favorite(Result<Void, Error>)
        case favoriteTapped
        case getRecipeDetails(Result<RecipeDetails, Error>)
        case rate(Result<RecipeDetails, Error>)
        case retryTapped
        case starTapped(Int)
        case viewDidLoad
    }

    enum Route {
        case back
    }

    public struct Dependencies {

        // MARK: - Properties

        public let recipesClient: RecipesClienting
        public let recipesFacade: RecipesFacading

        // MARK: - Lifecycle

        public init(recipesClient: RecipesClienting, recipesFacade: RecipesFacading) {
            self.recipesClient = recipesClient
            self.recipesFacade = recipesFacade
        }
    }

    public static func makeStore(dependencies: Dependencies, envelope: RecipeEnvelope) -> Store {
        let favoriteMiddleware = makeFavoriteMiddleware(dependencies: dependencies)
        let getRecipeDetailsMiddleware = makeGetRecipeDetailsMiddleware(dependencies: dependencies)
        let rateMiddleware = makeRateMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies, envelope: envelope),
            reducer: reduce,
            middlewares: [favoriteMiddleware, getRecipeDetailsMiddleware, rateMiddleware]
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
        case .backTapped:
            newState.route = .init(value: .back)

        case .favorite(let result):
            switch result {
            case .success:
                var details = newState.recipeDetails.getModel()
                details.isFavorite.toggle()
                newState.recipeDetails.handle(result: .success(details))

            case .failure(let error):
                newState.recipeDetails.handle(result: .failure(error))
            }

        case .favoriteTapped:
            break

        case .getRecipeDetails(let result):
            newState.recipeDetails.handle(result: result)

        case .rate(let result):
            newState.recipeDetails.handle(result: result)

        case .retryTapped:
            newState.recipeDetails.toggleIsLoading(on: true)

        case .starTapped(let index):
            var recipeDetails = newState.recipeDetails.getModel()
            recipeDetails.rating = index + 1
            newState.recipeDetails.update(with: recipeDetails)

        case .viewDidLoad:
            newState.recipeDetails.toggleIsLoading(on: true)
        }

        return newState
    }
}
