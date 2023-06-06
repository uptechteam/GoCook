//
//  SettingsViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension SettingsViewController {
    public static func resolve(coordinator: SettingsCoordinating) -> SettingsViewController {
        return SettingsViewController(
            presenter: SettingsPresenter(profileFacade: AppContainer.resolve()),
            coordinator: coordinator
        )
    }
}
