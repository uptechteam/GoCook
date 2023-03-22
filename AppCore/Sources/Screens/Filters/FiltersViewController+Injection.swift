//
//  FiltersViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension FiltersViewController {
    public static func resolve(coordinator: FiltersCoordinating) -> FiltersViewController {
        return FiltersViewController(
            presenter: FiltersPresenter(
                filtersFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
