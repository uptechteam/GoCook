//
//  FavoritesViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension FavoritesViewController {
    public static func resolve(coordinator: FavoritesCoordinating) -> FavoritesViewController {
        return FavoritesViewController(presenter: FavoritesPresenter(), coordinator: coordinator)
    }
}
