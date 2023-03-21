//
//  RecipeState.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import DomainModels
import Helpers

extension RecipePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        let recipe: Recipe
        var recipeDetails: DomainModelState<RecipeDetails>
        var route: AnyIdentifiable<Route>?

        var recipeName: String {
            recipeDetails.isPresent ? recipeDetails.name : recipe.name
        }

        var recipeImageSource: ImageSource {
            recipeDetails.isPresent ? recipeDetails.recipeImageSource : recipe.recipeImageSource
        }

        // MARK: - Public methods

        static func makeInitialState(envelope: RecipeEnvelope) -> State {
            return State(
                recipe: envelope.recipe,
                recipeDetails: DomainModelState(),
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case back
    }
}
