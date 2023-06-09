//
//  FavoritesCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import TabBar
import Author
import DomainModels
import Favorites
import Filters
import Library
import Recipe
import UIKit

protocol FavoritesCoordinatorDelegate: AnyObject {
    func didTapExplore()
}

@MainActor
final class FavoritesCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    weak var delegate: FavoritesCoordinatorDelegate?
    private var interactiveControllers: [Int: SwipeInteractionController]
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    private var tabBarController: TabBarController? {
        navigationController.tabBarController as? TabBarController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.childCoordinators = []
        self.interactiveControllers = [:]
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = FavoritesViewController.resolve(coordinator: self)
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

// MARK: - AuthorCoordinating

extension FavoritesCoordinator: AuthorCoordinating {
    func didTapBackOnAuthor() {
        navigationController.popViewController(animated: true)
    }

    func didTapRecipeOnAuthor(_ recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - FavoritesCoordinating

extension FavoritesCoordinator: FavoritesCoordinating {
    func didTapExplore() {
        delegate?.didTapExplore()
    }

    func didTapFilters() {
        let viewController = FiltersViewController.resolve(coordinator: self, envelope: .favorites)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapRecipe(_ recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - FiltersCoordinating

extension FavoritesCoordinator: FiltersCoordinating {
    func didApplyFilters() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - RecipeCoordinating

extension FavoritesCoordinator: RecipeCoordinating {
    func didTapAuthor(_ author: User) {
        let envelope = AuthorEnvelope(author: author)
        let viewController = AuthorViewController.resolve(coordinator: self, envelope: envelope)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapBack() {
        navigationController.popViewController(animated: true)
    }

    func didTapEditRecipe(_ recipeDetails: RecipeDetails) {
        let coordinator = ManageRecipeCoordinator(
            presentingViewController: navigationController,
            recipeDetails: recipeDetails
        )
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

// MARK: - UINavigationControllerdelegate

extension FavoritesCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if !viewController.isTabBarVisible {
            tabBarController?.toggleTabBarVisibility(on: false)
        }

        let isNavigationBarHidden = viewController is FavoritesViewController
        || viewController is RecipeViewController
        || viewController is AuthorViewController
        navigationController.setNavigationBarHidden(isNavigationBarHidden, animated: true)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        tabBarController?.toggleTabBarVisibility(on: viewController.isTabBarVisible)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        guard
            let transition = animationController as? PopTransition,
            let controller = interactiveControllers[transition.fromViewController.hash],
            controller.isInteractionInProgress
        else {
            return nil
        }

        return controller
    }

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            let controller = SwipeInteractionController(viewController: toVC)
            interactiveControllers[toVC.hash] = controller
            return PushTransition(snapshot: tabBarController?.makeTabBarSnapshot() ?? UIView())

        case .pop:
            return PopTransition(fromViewController: fromVC)

        default:
            return nil
        }
    }
}
