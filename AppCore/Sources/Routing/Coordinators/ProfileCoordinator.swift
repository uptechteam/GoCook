//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

final class ProfileCoordinator: Coordinating {

    // MARK: - Properties

    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Lifecycle

    func start() {
        let viewController = makeViewController()
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func makeViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .appWhite
        return viewController
    }
}
