//
//  RegistrationCoordinating.swift
//
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Foundation
import Login
import SignUp
import UIKit

protocol RegistrationCoordinatorDelegate: AnyObject {
    func registrationCoordiantorDidFinish(_ coordinator: RegistrationCoordinator)
}

final class RegistrationCoordinator: Coordinating {

    // MARK: - Properties

    private var childContainers: [Coordinating]
    private let navigationController: UINavigationController
    weak var delegate: RegistrationCoordinatorDelegate?

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childContainers = []
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = SignUpViewController.resolve(envelope: .registration, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Extensions

extension RegistrationCoordinator: SignUpCoordinating {
    func didFinishSignUp() {
        delegate?.registrationCoordiantorDidFinish(self)
    }

    func didTapLogin() {
        let viewController = LoginViewController.resolve(envelope: .registration, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension RegistrationCoordinator: LoginCoordinating {
    func didFinishLogin() {
        delegate?.registrationCoordiantorDidFinish(self)
    }

    func didTapSignUp() {
        let viewController = SignUpViewController.resolve(envelope: .registration, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
