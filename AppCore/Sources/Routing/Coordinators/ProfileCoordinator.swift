//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import AppTabBar
import Author
import CreateRecipe
import Dip
import DomainModels
import EditProfile
import Foundation
import Helpers
import Library
import Login
import Profile
import Recipe
import SignUp
import Settings
import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func profileCoordinatorDidFinish(_ coordinator: ProfileCoordinator)
}

final class ProfileCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    private let container: DependencyContainer
    private var interactiveControllers: [Int: SwipeInteractionController]
    private let navigationController: UINavigationController
    weak var delegate: ProfileCoordinatorDelegate?

    var rootViewController: UIViewController {
        navigationController
    }

    private var tabBarController: AppTabBarController? {
        navigationController.tabBarController as? AppTabBarController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.childCoordinators = []
        self.container = container
        self.interactiveControllers = [:]
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController = ProfileViewController.resolve(from: container, coordinator: self)
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

extension ProfileCoordinator: AuthorCoordinating {
    func didTapBackOnAuthor() {
        navigationController.popViewController(animated: true)
    }

    func didTapRecipeOnAuthor(_ recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - EditProfileCoordinating

extension ProfileCoordinator: EditProfileCoordinating {
    
}

// MARK: - ProfileCoordinating

extension ProfileCoordinator: ProfileCoordinating {
    func didTapCreateRecipe() {
        let coordinator = CreateRecipeCoordinator(container: container, presentingViewController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func didTapEdit() {
        let viewController = EditProfileViewController.resolve(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapRecipe(_ recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController = RecipeViewController.resolve(envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapSettings() {
        let viewController = SettingsViewController.resolve(from: container, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapSignIn() {
        let envelope = LoginEnvelope.profile
        let viewController = LoginViewController.resolve(from: container, envelope: envelope, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - RecipeCoordinating

extension ProfileCoordinator: RecipeCoordinating {
    func didTapAuthor(_ author: User) {
        let envelope = AuthorEnvelope(author: author)
        let viewController = AuthorViewController.resolve(coordinator: self, envelope: envelope)
        navigationController.pushViewController(viewController, animated: true)
    }

    func didTapBack() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - SettingsCoordinating

extension ProfileCoordinator: SettingsCoordinating {
    func didLogout() {
        delegate?.profileCoordinatorDidFinish(self)
    }
}

// MARK: - SignUpCoordinating

extension ProfileCoordinator: SignUpCoordinating {
    func didFinishSignUp() {
        navigationController.popToRootViewController(animated: true)
    }

    func didTapLogin() {
        let viewController = LoginViewController.resolve(from: container, envelope: .profile, coordinator: self)
        let viewControllers = [navigationController.viewControllers[0], viewController]
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - CreateRecipeCoordinatorDelegate

extension ProfileCoordinator: CreateRecipeCoordinatorDelegate {
    func didFinish(_ coordinator: CreateRecipeCoordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}

extension ProfileCoordinator: LoginCoordinating {
    func didFinishLogin() {
        navigationController.popToRootViewController(animated: true)
    }

    func didTapSignUp() {
        let envelope = SignUpEnvelope.profile
        let viewController = SignUpViewController.resolve(from: container, envelope: envelope, coordinator: self)
        let viewControllers = [navigationController.viewControllers[0], viewController]
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - UINavigationControllerdelegate

extension ProfileCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        if !viewController.isTabBarVisible {
            tabBarController?.toggleTabBarVisibility(on: false)
        }

        let isNavigationBarHidden = viewController is ProfileViewController
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
