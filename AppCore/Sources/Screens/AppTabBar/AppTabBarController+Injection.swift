//
//  AppTabBarController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension AppTabBarController {
    public static func resolve(coordinator: AppTabBarCoordinating) -> AppTabBarController {
        let dependencies = AppTabBarController.Dependencies()
        return AppTabBarController(
            store: AppTabBarController.makeStore(dependencies: dependencies),
            actionCreator: AppTabBarController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
