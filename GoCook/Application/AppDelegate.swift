//
//  AppDelegate.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import UIKit
import Routing

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var coordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.coordinator = AppCoordinator(window: UIWindow())
        self.coordinator?.start()
        return true
    }
}
