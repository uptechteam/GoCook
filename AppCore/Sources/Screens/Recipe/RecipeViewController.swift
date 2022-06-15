//
//  RecipeViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Combine
import Helpers
import UIKit

public protocol RecipeCoordinating: AnyObject {

}

public final class RecipeViewController: UIViewController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = RecipeView()
    private unowned let coordinator: RecipeCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: RecipeCoordinating
    ) {
        self.store = store
        self.actionCreator = actionCreator
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

    // MARK: - Private methods

    private func setupUI() {
        hidesBottomBarWhenPushed = true
        navigationItem.title = "Recipe"
    }

    private func setupBinding() {
        let state = store.state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state.map(RecipeViewController.makeProps(from:))
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)
    }
}
