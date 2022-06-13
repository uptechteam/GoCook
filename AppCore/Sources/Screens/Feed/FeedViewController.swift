//
//  FeedViewController.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 02.06.2022.
//

import Combine
import UIKit

public protocol FeedCoordinating: AnyObject {

}

public final class FeedViewController: UIViewController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = FeedView()
    private unowned let coordinator: FeedCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: FeedCoordinating
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
        let state = store.state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(FeedViewController.makeProps(from:))
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }
}
