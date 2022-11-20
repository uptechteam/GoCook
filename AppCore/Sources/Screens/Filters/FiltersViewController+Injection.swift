//
//  FiltersViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension FiltersViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: FiltersViewController.Dependencies.self,
            factory: FiltersViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: FiltersViewController.Store.self,
            factory: FiltersViewController.makeStore
        )
        container.register(
            .unique,
            type: FiltersViewController.ActionCreator.self,
            factory: FiltersViewController.ActionCreator.init
        )
        container.register(.unique, type: FiltersViewController.self) { coordinator in
            return FiltersViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: FiltersCoordinating
    ) -> FiltersViewController {
        try! container.resolve(arguments: coordinator)
    }
}
