//
//  CreateRecipeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import CreateRecipe
import Dip
import DomainModels
import Input
import Library
import UIKit

protocol CreateRecipeCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: CreateRecipeCoordinator)
}

final class CreateRecipeCoordinator: Coordinating {

    // MARK: - Properties

    weak var delegate: CreateRecipeCoordinatorDelegate?
    private let container: DependencyContainer
    private let presentingViewController: UIViewController
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        presentingViewController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, presentingViewController: UIViewController) {
        self.container = container
        self.presentingViewController = presentingViewController
        self.navigationController = UINavigationController()
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController = CreateRecipeViewController.resolve(from: container, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
        navigationController.modalPresentationStyle = .overFullScreen
        presentingViewController.present(navigationController, animated: true)
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

extension CreateRecipeCoordinator: CreateRecipeCoordinating {
    func didTapClose() {
        presentingViewController.dismiss(animated: true) { [self] in
            delegate?.didFinish(self)
        }
    }

    @MainActor
    func didTapInput(details: InputDetails) {
        let envelope = InputEnvelope(details: details)
        let viewController = InputViewController.resolve(from: container, envelope: envelope, coordinator: self)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }
}

extension CreateRecipeCoordinator: InputCoordinating {
    func didFinish(inputDetails: InputDetails) {
        navigationController.dismiss(animated: true)
        guard let viewController = navigationController.viewControllers.first as? CreateRecipeViewController else {
            return
        }

        viewController.updateInput(details: inputDetails)
    }
}
