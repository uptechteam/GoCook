//
//  ProfileViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension ProfileViewController {
    public static func resolve(coordinator: ProfileCoordinating) -> ProfileViewController {
        return ProfileViewController(
            presenter: ProfilePresenter(
                profileFacade: AppContainer.resolve(),
                profileRecipesFacade: AppContainer.resolve(),
                recipesFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
