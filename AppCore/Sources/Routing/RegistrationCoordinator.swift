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

@MainActor
final class RegistrationCoordinator: Coordinating {

    // MARK: - Properties

    weak var delegate: RegistrationCoordinatorDelegate?
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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

// MARK: - SignUpCoordinating

extension RegistrationCoordinator: SignUpCoordinating {
    func didFinishSignUp() {
        delegate?.registrationCoordiantorDidFinish(self)
    }

    func didTapLogin() {
        let viewController = LoginViewController.resolve(envelope: .registration, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

// MARK: - LoginCoordinating

extension RegistrationCoordinator: LoginCoordinating {
    func didFinishLogin() {
        delegate?.registrationCoordiantorDidFinish(self)
    }

    func didTapSignUp() {
        let viewController = SignUpViewController.resolve(envelope: .registration, coordinator: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}
