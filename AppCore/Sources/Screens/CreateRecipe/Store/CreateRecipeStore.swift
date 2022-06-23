//
//  CreateRecipeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Helpers

extension CreateRecipeViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case closeTapped
    }

    enum Route {
        case close
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
        return State(
            route: nil
        )
    }
}

extension CreateRecipeViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .closeTapped:
            newState.route = .init(value: .close)
        }

        return newState
    }
}

