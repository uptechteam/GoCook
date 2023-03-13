//
//  ProfileViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol ProfileCoordinating: AnyObject {
    func didTapCreateRecipe()
    func didTapEdit()
    func didTapRecipe(_ recipe: Recipe)
    func didTapSettings()
    func didTapSignIn()
}

public final class ProfileViewController: UIViewController, TabBarPresentable {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = ProfileView()
    private unowned let coordinator: ProfileCoordinating
    private var cancellables = [AnyCancellable]()

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    public var tabBarShouldBeVisible: Bool {
        true
    }

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: ProfileCoordinating
    ) {
        self.store = store
        self.actionCreator = actionCreator
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)

        navigationItem.backBarButtonItem = UIBarButtonItem(
            image: .backButton,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deinit \(self)")
    }

    public override func loadView() {
        view = contentView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        store.dispatch(action: .viewDidLoad)
    }

    // MARK: - Private methods

    private func setupBinding() {
        contentView.headerView.onTapEdit = { [store] in
            store.dispatch(action: .editTapped)
        }

        contentView.headerView.onTapSettings = { [store] in
            store.dispatch(action: .settingsTapped)
        }

        contentView.headerView.onTapSignIn = { [store] in
            store.dispatch(action: .signInTapped)
        }

        contentView.recipesHeaderView.onDidTapAddNew = { [store] in
            store.dispatch(action: .addNewRecipeTapped)
        }

        contentView.infoView.onDidTapAddRecipe = { [store] in
            store.dispatch(action: .addNewRecipeTapped)
        }

        contentView.onScrollToRefresh = { [store] in
            store.dispatch(action: .scrolledToRefresh)
        }

        contentView.onTapItem = { [store] indexPath in
            store.dispatch(action: .recipeTapped(indexPath))
        }

        contentView.onTapFavorite = { [store] indexPath in
            store.dispatch(action: .favoriteTapped(indexPath))
        }

        contentView.onScrollToEnd = { [store] in
            store.dispatch(action: .scrolledToEnd)
        }

        actionCreator.observeRecipes(handler: store.dispatch)
        actionCreator.subscribeToProfile(handler: store.dispatch)

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(ProfileViewController.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: Route) {
        switch route {
        case .createRecipe:
            coordinator.didTapCreateRecipe()

        case .edit:
            coordinator.didTapEdit()

        case .recipe(let recipe):
            coordinator.didTapRecipe(recipe)

        case .settings:
            coordinator.didTapSettings()

        case .signIn:
            coordinator.didTapSignIn()
        }
    }
}
