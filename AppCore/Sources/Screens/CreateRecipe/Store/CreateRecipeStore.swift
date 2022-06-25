//
//  CreateRecipeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import BusinessLogic
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
        case uploadImage(DomainModelAction<String>)
    }

    enum Route {
        case close
    }

    public struct Dependencies {

        // MARK: - Properties

        public let fileClient: FileClienting

        // MARK: - Lifecycle

        public init(fileClient: FileClienting) {
            self.fileClient = fileClient
        }
    }

    public static func makeStore(dependencies: Dependencies) -> Store {
        let uploadImageMiddleware = makeUploadImageMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [uploadImageMiddleware]
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

        case .uploadImage:
            break
        }

        return newState
    }
}

