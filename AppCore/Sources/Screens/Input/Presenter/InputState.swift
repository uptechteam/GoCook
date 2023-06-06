//
//  InputState.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import DomainModels
import Helpers

extension InputPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        let inputDetails: InputDetails
        var text: String
        var unit: IngredientUnit?
        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        static func makeInitialState(envelope: InputEnvelope) -> State {
            return State(
                inputDetails: envelope.details,
                text: envelope.details.text,
                unit: nil,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case finish(InputDetails)
    }
}
