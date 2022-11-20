//
//  HomeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension HomeViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: HomeViewController.Dependencies.self,
            factory: HomeViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: HomeViewController.Store.self,
            factory: HomeViewController.makeStore
        )
        container.register(
            .unique,
            type: HomeViewController.ActionCreator.self,
            factory: HomeViewController.ActionCreator.init
        )
        container.register(.unique, type: HomeViewController.self) { coordinator in
            return HomeViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: HomeCoordinating
    ) -> HomeViewController {
        try! container.resolve(arguments: coordinator)
    }
}
