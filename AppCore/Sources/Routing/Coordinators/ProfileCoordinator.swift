//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Dip
import Foundation
import Library
import Profile
import UIKit

final class ProfileCoordinator: NSObject, Coordinating {

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
        super.init()
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController: ProfileViewController = try! container.resolve(arguments: self as ProfileCoordinating)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.delegate = self
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - Extensions

extension ProfileCoordinator: ProfileCoordinating {

}

// MARK: - UINavigationControllerdelegate

extension ProfileCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let isHidden = viewController is ProfileViewController
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
}
