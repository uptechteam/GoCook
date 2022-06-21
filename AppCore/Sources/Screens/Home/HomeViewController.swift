//
//  HomeViewController.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import Combine
import DomainModels
import UIKit

public protocol HomeCoordinating: AnyObject {
    func showFilters()
    func show(recipe: Recipe)
}

public final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = HomeView()
    private unowned let coordinator: HomeCoordinating
    private var cancellables = [AnyCancellable]()

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

        store.dispatch(action: .getFeed(.trigger))
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
        contentView.onDidChangeSearchQuery = { [store] query in
            store.dispatch(action: .didChangeSearchQuery(query))
        }

        contentView.onDidTapFilters = { [store] in
            store.dispatch(action: .didTapFilters)
        }

        contentView.onDidTapViewAll = { [store] indexPath in
            store.dispatch(action: .didTapViewAll(indexPath))
        }

        contentView.onDidTapItem = { [store] indexPath in
            store.dispatch(action: .didTapItem(indexPath))
        }

        contentView.onDidTapLike = { [store] indexPath in
            store.dispatch(action: .didTapLike(indexPath))
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(HomeViewController.makeProps(from:))
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in
                navigate(by: route)
            }
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
