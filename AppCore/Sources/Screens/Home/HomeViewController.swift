//
//  HomeViewController.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import Combine
import DomainModels
import Library
import UIKit

public protocol HomeCoordinating: AnyObject {
    func showFilters()
    func show(recipe: Recipe)
}

public final class HomeViewController: UIViewController, TabBarPresentable {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = HomeView()
    private unowned let coordinator: HomeCoordinating
    private var cancellables = [AnyCancellable]()

    public var tabBarShouldBeVisible: Bool {
        true
    }

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: HomeCoordinating
    ) {
        self.store = store
        self.actionCreator = actionCreator
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
        store.dispatch(action: .viewDidLoad)
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
        contentView.onChangeSearchQuery = { [store] query in
            store.dispatch(action: .searchQueryChanged(query))
        }

        contentView.onTapFilters = { [store] in
            store.dispatch(action: .filtersTapped)
        }

        contentView.feedView.trendingCategoryView.categoriesListView.onTapItem = { [store] indexPath in
            store.dispatch(action: .categoryTapped(indexPath))
        }

        contentView.feedView.trendingCategoryView.headerView.onTapViewAll = { [store] in
            store.dispatch(action: .viewAllTapped(0, isTrending: true))
        }

        contentView.feedView.trendingCategoryView.recipesListView.onTapItem = { [store] indexPath in
            store.dispatch(action: .recipeTapped(indexPath, isTrending: true))
        }

        contentView.feedView.trendingCategoryView.recipesListView.onTapFavorite = { [store] indexPath in
            store.dispatch(action: .favoriteTapped(indexPath, isTrending: true))
        }

        contentView.feedView.onTapViewAll = { [store] index in
            store.dispatch(action: .viewAllTapped(index, isTrending: false))
        }

        contentView.feedView.onTapRecipe = { [store] indexPath in
            store.dispatch(action: .recipeTapped(indexPath, isTrending: false))
        }

        contentView.feedView.onTapFavorite = { [store] indexPath in
            store.dispatch(action: .favoriteTapped(indexPath, isTrending: false))
        }

        contentView.searchResultsView.onTapItem = { [store] indexPath in
            store.dispatch(action: .searchRecipeTapped(indexPath))
        }

        contentView.searchResultsView.onTapFavorite = { [store] indexPath in
            store.dispatch(action: .searchFavoriteTapped(indexPath))
        }

        contentView.searchResultsView.onScrollToEnd = { [store] in
            store.dispatch(action: .scrolledSearchToEnd)
        }

        actionCreator.observeFeed(handler: store.dispatch)
        actionCreator.observeRecipes(handler: store.dispatch)

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(HomeViewController.makeProps)
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
        case .filters:
            coordinator.showFilters()

        case .itemDetails(let recipe):
            coordinator.show(recipe: recipe)

        case .recipeCategory(let category):
            print("Show category: \(category)")
        }
    }
}
