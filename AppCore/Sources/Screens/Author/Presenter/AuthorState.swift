//
//  AuthorState.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import DomainModels
import Helpers

extension AuthorPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        let author: User
        var recipes: DomainModelState<[Recipe]>
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        var isEmptyContent: Bool {
            recipes.isPresent && recipes.isEmpty
        }

        var isErrorPresent: Bool {
            recipes.isEmpty && recipes.error != nil
        }

        // MARK: - Public methods

        static func makeInitialState(envelope: AuthorEnvelope) -> State {
            return State(
                author: envelope.author,
                recipes: DomainModelState(),
                alert: nil,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Alert {
        case error(message: String)
    }

    enum Route {
        case didTapBack
        case didTapRecipe(Recipe)
    }
}
