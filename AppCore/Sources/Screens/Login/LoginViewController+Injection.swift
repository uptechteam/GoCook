//
//  LoginViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension LoginViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: LoginViewController.Dependencies.self,
            factory: LoginViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: LoginViewController.Store.self,
            factory: { envelope in
                LoginViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: LoginViewController.ActionCreator.self,
            factory: LoginViewController.ActionCreator.init
        )
        container.register(.unique, type: LoginViewController.self) { (envelope: LoginEnvelope, coordinator) in
            return LoginViewController(
                store: try container.resolve(arguments: envelope),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        envelope: LoginEnvelope,
        coordinator: LoginCoordinating
    ) -> LoginViewController {
        try! container.resolve(arguments: envelope, coordinator)
    }
}
