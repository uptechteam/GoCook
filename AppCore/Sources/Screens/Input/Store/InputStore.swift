//
//  InputStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import BusinessLogic
import Helpers

extension InputViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var text: String
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case saveTapped
        case textChanged(String)
    }

    enum Route {
        case finish(String)
    }

    public struct Dependencies {

        // MARK: - Properties

        public let keyboardManager: KeyboardManaging

        // MARK: - Lifecycle

        public init(keyboardManager: KeyboardManaging) {
            self.keyboardManager = keyboardManager
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
            text: "",
            route: nil
        )
    }
}

extension InputViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .saveTapped:
            newState.route = .init(value: .finish(newState.text))

        case .textChanged(let text):
            newState.text = text
        }

        return newState
    }
}

