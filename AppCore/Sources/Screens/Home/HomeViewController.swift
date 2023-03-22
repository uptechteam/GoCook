//
//  HomeViewController.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import Combine
import DomainModels
import Helpers
import Library
import UIKit

public protocol HomeCoordinating: AnyObject {
    func showFilters()
    func show(recipe: Recipe)
}

public final class HomeViewController: UIViewController, TabBarPresentable {

    // MARK: - Properties

    private let presenter: HomePresenter
    private let contentView = HomeView()
    private unowned let coordinator: HomeCoordinating
    private var cancellables = [AnyCancellable]()

    public var tabBarShouldBeVisible: Bool {
        true
    }

    // MARK: - Lifecycle

    public init(presenter: HomePresenter, coordinator: HomeCoordinating) {
        self.presenter = presenter
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
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
        setupUI()
        setupBinding()
        Task {
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
        contentView.onChangeSearchQuery = { [presenter] query in
            presenter.searchQueryChanged(query: query)
        }

        contentView.onTapFilters = { [presenter] in
            presenter.filtersTapped()
        }

        contentView.feedView.trendingCategoryView.categoriesListView.onTapItem = { [presenter] indexPath in
            presenter.categoryTapped(indexPath: indexPath)
        }

        contentView.feedView.trendingCategoryView.headerView.onTapViewAll = toSyncClosure { [presenter] in
            await presenter.viewAllTapped(index: 0, isTrending: true)
        }

        contentView.feedView.trendingCategoryView.recipesListView.onTapItem = { [presenter] indexPath in
            presenter.recipeTapped(indexPath: indexPath, isTrending: true)
        }

        contentView.feedView.trendingCategoryView.recipesListView.onTapFavorite = toSyncClosure { [presenter] indexPath in
            await presenter.favoriteTapped(indexPath: indexPath, isTrending: true)
        }

        contentView.feedView.onTapViewAll = toSyncClosure { [presenter] index in
            await presenter.viewAllTapped(index: index, isTrending: false)
        }

        contentView.feedView.onTapRecipe = { [presenter] indexPath in
            presenter.recipeTapped(indexPath: indexPath, isTrending: false)
        }

        contentView.feedView.onTapFavorite = toSyncClosure { [presenter] indexPath in
            await presenter.favoriteTapped(indexPath: indexPath, isTrending: false)
        }

        contentView.searchResultsView.onTapItem = { [presenter] indexPath in
            presenter.searchRecipeTapped(indexPath: indexPath)
        }

        contentView.searchResultsView.onTapFavorite = toSyncClosure { [presenter] indexPath in
            await presenter.searchFavoriteTapped(indexPath: indexPath)
        }

        contentView.searchResultsView.onScrollToEnd = { [presenter] in
            presenter.scrolledSearchToEnd()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in HomePresenter.makeProps(from: state) }
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route)
            .removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: HomePresenter.Route) {
        switch route {
        case .didTapFilters:
            coordinator.showFilters()

        case .didTapRecipe(let recipe):
            coordinator.show(recipe: recipe)
        }
    }
}
