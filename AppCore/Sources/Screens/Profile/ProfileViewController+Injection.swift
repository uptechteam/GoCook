//
//  ProfileViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension ProfileViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: ProfileViewController.Dependencies.self,
            factory: ProfileViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: ProfileViewController.Store.self,
            factory: ProfileViewController.makeStore
        )
        container.register(
            .unique,
            type: ProfileViewController.ActionCreator.self,
            factory: ProfileViewController.ActionCreator.init
        )
        container.register(.unique, type: ProfileViewController.self) { coordinator in
            return ProfileViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: ProfileCoordinating
    ) -> ProfileViewController {
        try! container.resolve(arguments: coordinator)
    }
}
