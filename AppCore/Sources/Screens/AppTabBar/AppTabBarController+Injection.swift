//
//  AppTabBarController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension AppTabBarController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: AppTabBarController.Dependencies.self,
            factory: AppTabBarController.Dependencies.init
        )
        container.register(
            .unique,
            type: AppTabBarController.Store.self,
            factory: AppTabBarController.makeStore(dependencies:)
        )
        container.register(
            .unique,
            type: AppTabBarController.ActionCreator.self,
            factory: AppTabBarController.ActionCreator.init
        )
        container.register(.unique, type: AppTabBarController.self) { coordinator in
            return AppTabBarController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: AppTabBarCoordinating
    ) -> AppTabBarController {
        try! container.resolve(arguments: coordinator)
    }
}
