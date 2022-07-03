//
//  RegistrationCoordinating.swift
//
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Dip
import Foundation
import SignUp
import UIKit

public final class RegistrationCoordinator: Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private var childContainers: [Coordinating]
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    public init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.childContainers = []
        setupUI()
    }

    // MARK: - Public methods

    public func start() {
        let viewController: SignUpViewController = try! container.resolve(arguments: self as SignUpCoordinating)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Extensions

extension RegistrationCoordinator: SignUpCoordinating {

}
