//
//  File.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers

extension FiltersViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {

    }

    public enum Action {

    }

    enum Route {

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
        return State()
    }
}

extension FiltersViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {

        }

        return newState
    }
}
