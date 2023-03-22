//
//  HomeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic
import DomainModels

extension HomeViewController {
    public static func resolve(coordinator: HomeCoordinating) -> HomeViewController {
        return HomeViewController(
            presenter: HomePresenter(
                filtersFacade: AppContainer.resolve(tag: FiltersFacadeTag.home),
                homeFeedFacade: AppContainer.resolve(),
                recipesFacade: AppContainer.resolve(),
                searchRecipesFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
