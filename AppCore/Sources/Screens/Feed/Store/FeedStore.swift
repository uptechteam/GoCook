//
//  FeedStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Foundation
import Helpers

public extension FeedViewController {

    typealias Store = ReduxStore<State, Action>

    struct State: Equatable {
        
    }

    enum Action {

    }

    enum Route {

    }

    struct Dependencies {
        public init() {

        }
    }

    static func makeStore(dependencies: Dependencies) -> Store {
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

extension FeedViewController {
    static func reduce(state: State, action: Action) -> State {

        let newState = state

        switch action {

        }

        return newState
    }
}
