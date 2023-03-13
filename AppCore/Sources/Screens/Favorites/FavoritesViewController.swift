//
//  FavoritesViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import UIKit

public protocol FavoritesCoordinating: AnyObject {

}

public final class FavoritesViewController: UIViewController {

    // MARK: - Properties

    private let presenter: FavoritesPresenter
    private let contentView = FavoritesView()
    private unowned let coordinator: FavoritesCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: FavoritesPresenter, coordinator: FavoritesCoordinating) {
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
        setupBinding()
    }

    // MARK: - Private methods

    private func setupBinding() {
        contentView.onTapFilters = asSyncClosure { [presenter] in
            await presenter.filterTapped()
        }

        contentView.onChangeSearchQuery = asSyncClosure { [presenter] text in
            await presenter.searchQueryChanged(text)
        }
    }
}

public func asSyncClosure<T>(callback: @escaping @Sendable (T) async -> Void) -> ((T) -> Void) {
    return { argument in
        Task {
            await callback(argument)
        }
    }
}

public func asSyncClosure(callback: @escaping @Sendable () async -> Void) -> (() -> Void) {
    return {
        Task {
            await callback()
        }
    }
}
