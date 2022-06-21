//
//  RecipeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Foundation
import Helpers

extension RecipeViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        let recipe: Recipe
        var recipeDetails: RecipeDetails?
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case backTapped
    }

    enum Route {
        case back
    }

    public struct Dependencies {
        public init() {

        }
    }

    public static func makeStore(dependencies: Dependencies, envelope: RecipeEnvelope) -> Store {
        return Store(
            initialState: makeInitialState(dependencies: dependencies, envelope: envelope),
            reducer: reduce,
            middlewares: []
        )
    }

    private static func makeInitialState(dependencies: Dependencies, envelope: RecipeEnvelope) -> State {
        return State(
            recipe: envelope.recipe,
            recipeDetails: nil,
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
        }

        return newState
    }
}
