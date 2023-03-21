//
//  ViewControllersInjection.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import AppTabBar
import CreateRecipe
import Dip
import Favorites
import Filters
import Home
import Input
import Login
import Recipe
import Profile
import Settings
import SignUp

extension DependencyContainer {
    public static func injectViewControllers(container: DependencyContainer) {
        AppTabBarController.inject(into: container)
        CreateRecipeViewController.inject(into: container)
        HomeViewController.inject(into: container)
        InputViewController.inject(into: container)
        LoginViewController.inject(into: container)
        ProfileViewController.inject(into: container)
        SettingsViewController.inject(into: container)
        SignUpViewController.inject(into: container)
    }
}
