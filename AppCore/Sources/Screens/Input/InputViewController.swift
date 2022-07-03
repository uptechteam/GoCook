//
//  InputViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Combine
import DomainModels
import UIKit

public protocol InputCoordinating: AnyObject {
    func didFinish(inputDetails: InputDetails)
}

public final class InputViewController: UIViewController {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = InputView()
    private unowned let coordinator: InputCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: InputCoordinating
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
        contentView.activateTextField()
    }

    // MARK: - Private methods

    private func setupBinding() {
        actionCreator.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        contentView.onDidChangeText = { [store] text in
            store.dispatch(action: .textChanged(text))
        }

        contentView.onDidTapSave = { [store] in
            store.dispatch(action: .saveTapped)
        }

        contentView.unitView.onDidSelectItem = { [store] index in
            store.dispatch(action: .unitSelected(index))
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(InputViewController.makeProps)
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
        case .finish(let details):
            coordinator.didFinish(inputDetails: details)
        }
    }
}

