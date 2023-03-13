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
            type: FavoritesPresenter.Dependencies.self,
            factory: FavoritesPresenter.Dependencies.init
        )
        container.register(
            .unique,
            type: FavoritesPresenter.self,
            factory: FavoritesPresenter.init
        )
        container.register(.unique, type: FavoritesViewController.self) { coordinator in
            return FavoritesViewController(
                presenter: try container.resolve(),
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
