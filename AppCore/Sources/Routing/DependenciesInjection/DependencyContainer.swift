//
//  DependencyContainer.swift
//
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import BusinessLogic
import Dip
import Foundation

extension DependencyContainer {
    public static func configure() -> DependencyContainer {
        return DependencyContainer { container in

            // MARK: - Networking

            container.register(.singleton, type: NetworkClient.self, factory: NetworkClientImpl.init)
            container.register(.singleton, type: RecipesClienting.self, factory: RecipesClient.init)

            // MARK: - View controllers injection

            injectViewControllers(container: container)
        }
    }
}