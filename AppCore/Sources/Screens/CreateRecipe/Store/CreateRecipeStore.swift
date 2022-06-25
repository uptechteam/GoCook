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
        var recipeImageSource: ImageSource?
        var step: Int
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case backTapped
        case closeTapped
        case imagePicked(ImageSource)
        case nextTapped
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
            recipeImageSource: nil,
            step: 0,
            route: nil
        )
    }
}

extension CreateRecipeViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .backTapped:
            newState.step = max(0, newState.step - 1)

        case .closeTapped:
            newState.route = .init(value: .close)

        case .imagePicked(let imageSource):
            newState.recipeImageSource = imageSource

        case .nextTapped:
            newState.step = min(3, newState.step + 1)
        }

        return newState
    }
}

