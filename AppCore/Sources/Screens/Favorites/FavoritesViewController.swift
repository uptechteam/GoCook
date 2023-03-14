//
//  FavoritesViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol FavoritesCoordinating: AnyObject {
    func didTapExplore()
    func didTapFilters()
    func didTapRecipe(_ recipe: Recipe)
}

public final class FavoritesViewController: UIViewController, TabBarPresentable {

    // MARK: - Properties

    private let presenter: FavoritesPresenter
    private let contentView = FavoritesView()
    private unowned let coordinator: FavoritesCoordinating
    private var cancellables = [AnyCancellable]()

    public var tabBarShouldBeVisible: Bool {
        true
    }

    // MARK: - Lifecycle

    public init(presenter: FavoritesPresenter, coordinator: FavoritesCoordinating) {
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
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task { [presenter] in
            await presenter.viewDidAppear()
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
        contentView.onTapFilters = { [presenter] in
            presenter.filtersTapped()
        }

        contentView.onChangeSearchQuery = { [presenter] text in
            presenter.searchQueryChanged(text)
        }

        contentView.recipesView.onTapItem = { [presenter] indexPath in
            presenter.recipeTapped(indexPath: indexPath)
        }

        contentView.recipesView.onTapFavorite = toSyncClosure { [presenter] indexPath in
            await presenter.favoriteTapped(indexPath: indexPath)
        }

        contentView.contentStateView.onTapAction = toSyncClosure { [presenter] in
            await presenter.contentStateActionTapped()
        }

        let state = presenter.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(FavoritesViewController.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: FavoritesPresenter.Route) {
        switch route {
        case .didTapExplore:
            coordinator.didTapExplore()

        case .didTapFilters:
            coordinator.didTapFilters()

        case .didTapRecipe(let recipe):
            coordinator.didTapRecipe(recipe)
        }
    }
}
