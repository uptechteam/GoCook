//
//  TabBarState.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import Helpers

extension TabBarPresenter {

    struct State: Equatable {

        // MARK: - Properties

        var activeIndex: Int
        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                activeIndex: 0
            )
        }
    }

    // MARK: - Route

    enum Route {

    }
}
