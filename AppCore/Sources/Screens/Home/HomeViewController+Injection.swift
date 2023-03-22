//
//  HomeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension HomeViewController {
    public static func resolve(coordinator: HomeCoordinating) -> HomeViewController {
        return HomeViewController(
            presenter: HomePresenter(
                homeFeedFacade: AppContainer.resolve(),
                recipesFacade: AppContainer.resolve(),
                searchRecipesFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
