//
//  FavoritesViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension FavoritesViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: FavoritesViewController.Dependencies.self,
            factory: FavoritesViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: FavoritesViewController.Store.self,
            factory: FavoritesViewController.makeStore
        )
        container.register(
            .unique,
            type: FavoritesViewController.ActionCreator.self,
            factory: FavoritesViewController.ActionCreator.init
        )
        container.register(.unique, type: FavoritesViewController.self) { coordinator in
            return FavoritesViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: FavoritesCoordinating
    ) -> FavoritesViewController {
        try! container.resolve(arguments: coordinator)
    }
}
