//
//  ProfileViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension ProfileViewController {
    public static func resolve(coordinator: ProfileCoordinating) -> ProfileViewController {
        let dependencies = ProfileViewController.Dependencies(
            profileFacade: AppContainer.resolve(),
            profileRecipesFacade: AppContainer.resolve(),
            recipesFacade: AppContainer.resolve()
        )
        return ProfileViewController(
            store: ProfileViewController.makeStore(dependencies: dependencies),
            actionCreator: ProfileViewController.ActionCreator(dependencies: dependencies),
            coordinator: coordinator
        )
    }
}
