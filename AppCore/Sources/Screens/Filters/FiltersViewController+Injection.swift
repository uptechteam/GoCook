//
//  FiltersViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

extension FiltersViewController {
    public static func resolve(coordinator: FiltersCoordinating) -> FiltersViewController {
        return FiltersViewController(presenter: FiltersPresenter(), coordinator: coordinator)
    }
}
