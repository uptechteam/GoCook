//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Dip
import Library
import Profile
import UIKit

final class ProfileCoordinator: Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController: ProfileViewController = try! container.resolve(arguments: self as ProfileCoordinating)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - Extensions

extension ProfileCoordinator: ProfileCoordinating {

}
