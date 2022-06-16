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

    public static func makeStore(dependencies: Dependencies) -> Store {
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: []
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        let url = URL(string: "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg")!
        return State(
            recipe: Recipe(
                id: .init(rawValue: UUID().uuidString),
                name: "Green Hummus with sizzled dolmades",
                recipeImageSource: .remote(url: url),
                rating: 4.8
            ),
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
