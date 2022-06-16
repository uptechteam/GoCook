//
//  AppTabBarStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers

extension AppTabBarController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var activeIndex: Int
    }

    public enum Action {
        case itemTapped(Int)
        case selectInitialItem
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
        return State(
            activeIndex: 0
        )
    }
}

extension AppTabBarController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .itemTapped(let index):
            newState.activeIndex = index

        case .selectInitialItem:
            newState.activeIndex = 1
        }

        return newState
    }
}
