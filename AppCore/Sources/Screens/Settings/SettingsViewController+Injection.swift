//
//  SettingsViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension SettingsViewController {
    public static func resolve(coordinator: SettingsCoordinating) -> SettingsViewController {
        let dependencies = SettingsViewController.Dependencies(profileFacade: AppContainer.resolve())
        return SettingsViewController(
            store: SettingsViewController.makeStore(dependencies: dependencies),
            actionCreator: SettingsViewController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
