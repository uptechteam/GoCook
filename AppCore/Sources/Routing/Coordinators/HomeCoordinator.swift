//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import AppTabBar
import BusinessLogic
import DomainModels
import Dip
import Filters
import Foundation
import Home
import Library
import Recipe
import UIKit

final class HomeCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private let navigationController: UINavigationController
    private var interactiveControllers: [Int: SwipeInteractionController]

    var rootViewController: UIViewController {
        navigationController
    }

    private var tabBarController: AppTabBarController? {
        navigationController.tabBarController as? AppTabBarController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        self.interactiveControllers = [:]
        super.init()
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = HomeViewController.resolve(from: container, coordinator: self)
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

// MARK: - Coordinating extensions

extension HomeCoordinator: HomeCoordinating {
    func showFilters() {
        let viewController = FiltersViewController.resolve(from: container, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func show(recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(from: container, envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: FiltersCoordinating {

}

extension HomeCoordinator: RecipeCoordinating {
    func didTapBack() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerdelegate

extension HomeCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if !viewController.isTabBarVisible {
            tabBarController?.toggleTabBarVisibility(on: false)
        }

        let isNavigationBarHidden = viewController is HomeViewController || viewController is RecipeViewController
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
