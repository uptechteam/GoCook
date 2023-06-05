//
//  AppTabBarController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

extension TabBarController {
    public static func resolve(coordinator: TabBarCoordinating) -> TabBarController {
        return TabBarController(
            presenter: TabBarPresenter(),
            coordinator: coordinator
        )
    }
}
