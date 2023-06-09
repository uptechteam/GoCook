//
//  ProfileState.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import DomainModels
import Helpers

extension ProfilePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var profile: Profile?
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?

        var isEmptyContent: Bool {
            profile != nil && recipes.isPresent && recipes.isEmpty
        }

        var isErrorPresent: Bool {
            recipes.isEmpty && recipes.error != nil
        }

        var isNotSignedIn: Bool {
            profile == nil
        }

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                profile: nil,
                recipes: DomainModelState(),
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case didTapCreateRecipe
        case didTapEdit
        case didTapRecipe(Recipe)
        case didTapSettings
        case didTapSignIn
    }
}
