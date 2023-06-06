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
    func didTapManageRecipe()
    func didTapEdit()
    func didTapRecipe(_ recipe: Recipe)
    func didTapSettings()
    func didTapSignIn()
}

public final class ProfileViewController: UIViewController, TabBarPresentable {

    // MARK: - Properties

    private let presenter: ProfilePresenter
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

    public init(presenter: ProfilePresenter, coordinator: ProfileCoordinating) {
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        setupUI()
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
        Task { [presenter] in
            await presenter.viewDidLoad()
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(
            image: .backButton,
            style: .plain,
            target: nil,
            action: nil
        )
    }

    private func setupBinding() {
        contentView.headerView.onTapEdit = { [presenter] in
            presenter.editTapped()
        }

        contentView.headerView.onTapSettings = { [presenter] in
            presenter.settingsTapped()
        }

        contentView.headerView.onTapSignIn = { [presenter] in
            presenter.signInTapped()
        }

        contentView.recipesHeaderView.onDidTapAddNew = { [presenter] in
            presenter.addNewRecipeTapped()
        }

        contentView.infoView.onDidTapAddRecipe = { [presenter] in
            presenter.addNewRecipeTapped()
        }

        contentView.onScrollToRefresh = toSyncClosure { [presenter] in
            await presenter.scrolledToRefresh()
        }

        contentView.onTapItem = { [presenter] indexPath in
            presenter.recipeTapped(indexPath: indexPath)
        }

        contentView.onTapFavorite = toSyncClosure { [presenter] indexPath in
            await presenter.favoriteTapped(indexPath: indexPath)
        }

        contentView.onScrollToEnd = toSyncClosure { [presenter] in
            await presenter.scrolledToEnd()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map(ProfilePresenter.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: ProfilePresenter.Route) {
        switch route {
        case .createRecipe:
            coordinator.didTapManageRecipe()

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
