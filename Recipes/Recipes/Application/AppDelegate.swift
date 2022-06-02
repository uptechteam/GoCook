//
//  AppDelegate.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow()
        window.makeKeyAndVisible()
        self.window = window
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        window.rootViewController = viewController
        return true
    }
}
