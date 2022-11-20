//
//  SettingsViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension SettingsViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: SettingsViewController.Dependencies.self,
            factory: SettingsViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: SettingsViewController.Store.self,
            factory: SettingsViewController.makeStore(dependencies:)
        )
        container.register(
            .unique,
            type: SettingsViewController.ActionCreator.self,
            factory: SettingsViewController.ActionCreator.init
        )
        container.register(.unique, type: SettingsViewController.self) { coordinator in
            return SettingsViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    public static func resolve(
        from container: DependencyContainer,
        coordinator: SettingsCoordinating
    ) -> SettingsViewController {
        try! container.resolve(arguments: coordinator)
    }
}
