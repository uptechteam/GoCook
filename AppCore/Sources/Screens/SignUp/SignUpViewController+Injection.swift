//
//  SignUpViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension SignUpViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: SignUpViewController.Dependencies.self,
            factory: SignUpViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: SignUpViewController.Store.self,
            factory: { envelope in
                SignUpViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: SignUpViewController.ActionCreator.self,
            factory: SignUpViewController.ActionCreator.init
        )
        container.register(.unique, type: SignUpViewController.self) { (envelope: SignUpEnvelope, coordinator) in
            return SignUpViewController(
                store: try container.resolve(arguments: envelope),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        envelope: SignUpEnvelope,
        coordinator: SignUpCoordinating
    ) -> SignUpViewController {
        try! container.resolve(arguments: envelope, coordinator)
    }
}
