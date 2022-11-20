//
//  InputViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension InputViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: InputViewController.Dependencies.self,
            factory: InputViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: InputViewController.Store.self,
            factory: { envelope in
                InputViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: InputViewController.ActionCreator.self,
            factory: InputViewController.ActionCreator.init
        )
        container.register(.unique, type: InputViewController.self) { (envelope: InputEnvelope, coordinator) in
            return InputViewController(
                store: try container.resolve(arguments: envelope),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        envelope: InputEnvelope,
        coordinator: InputCoordinating
    ) -> InputViewController {
        try! container.resolve(arguments: envelope, coordinator)
    }
}
