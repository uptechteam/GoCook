//
//  ManageRecipeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels
import Input
import Library
import ManageRecipe
import UIKit

protocol ManageRecipeCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: ManageRecipeCoordinator)
}

@MainActor
final class ManageRecipeCoordinator: Coordinating {

    // MARK: - Properties

    weak var delegate: ManageRecipeCoordinatorDelegate?
    private let navigationController: UINavigationController
    private let presentingViewController: UIViewController
    private let recipeDetails: RecipeDetails?

    var rootViewController: UIViewController {
        presentingViewController
    }

    // MARK: - Lifecycle

    init(presentingViewController: UIViewController, recipeDetails: RecipeDetails?) {
        self.navigationController = BaseNavigationController()
        self.presentingViewController = presentingViewController
        self.recipeDetails = recipeDetails
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let envelope = recipeDetails.flatMap(ManageRecipeEnvelope.edit) ?? .create
        let viewController = ManageRecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
        presentingViewController.present(navigationController, animated: true)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - InputCoordinating

extension ManageRecipeCoordinator: InputCoordinating {
    func didFinish(inputDetails: InputDetails) {
        navigationController.dismiss(animated: true)
        guard let viewController = navigationController.viewControllers.first as? ManageRecipeViewController else {
            return
        }

        viewController.updateInput(details: inputDetails)
    }
}

// MARK: - ManageRecipeCoordinating

extension ManageRecipeCoordinator: ManageRecipeCoordinating {
    func didTapClose() {
        presentingViewController.dismiss(animated: true) { [self] in
            delegate?.didFinish(self)
        }
    }

    func didTapInput(details: InputDetails) {
        let envelope = InputEnvelope(details: details)
        let viewController = InputViewController.resolve(envelope: envelope, coordinator: self)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }
}
