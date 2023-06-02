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

final class ManageRecipeCoordinator: Coordinating {

    // MARK: - Properties

    weak var delegate: ManageRecipeCoordinatorDelegate?
    private let recipeDetails: RecipeDetails?
    private let presentingViewController: UIViewController
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        presentingViewController
    }

    // MARK: - Lifecycle

    init(recipeDetails: RecipeDetails?, presentingViewController: UIViewController) {
        self.recipeDetails = recipeDetails
        self.presentingViewController = presentingViewController
        self.navigationController = BaseNavigationController()
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let envelope = recipeDetails.flatMap(ManageRecipeEnvelope.edit) ?? .create
        let viewController = ManageRecipeViewController.resolve(envelope: envelope, coordinator: self)
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

extension ManageRecipeCoordinator: ManageRecipeCoordinating {
    func didTapClose() {
        presentingViewController.dismiss(animated: true) { [self] in
            delegate?.didFinish(self)
        }
    }

    @MainActor
    func didTapInput(details: InputDetails) {
        let envelope = InputEnvelope(details: details)
        let viewController = InputViewController.resolve(envelope: envelope, coordinator: self)
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        navigationController.present(viewController, animated: true)
    }
}

extension ManageRecipeCoordinator: InputCoordinating {
    func didFinish(inputDetails: InputDetails) {
        navigationController.dismiss(animated: true)
        guard let viewController = navigationController.viewControllers.first as? ManageRecipeViewController else {
            return
        }

        viewController.updateInput(details: inputDetails)
    }
}
