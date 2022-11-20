//
//  UIViewController+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import UIKit

extension UIViewController {
    public var isTabBarVisible: Bool {
        (self as? TabBarPresentable)?.tabBarShouldBeVisible ?? false
    }
}
