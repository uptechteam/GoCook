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

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = FavoritesView()
    private unowned let coordinator: FavoritesCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: FavoritesCoordinating
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
        setupBinding()
    }

    // MARK: - Private methods

    private func setupBinding() {

    }
}
