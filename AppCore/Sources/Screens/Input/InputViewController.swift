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

    private let presenter: InputPresenter
    private let contentView = InputView()
    private unowned let coordinator: InputCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: InputPresenter, coordinator: InputCoordinating) {
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.activateTextField()
    }

    // MARK: - Private methods

    private func setupBinding() {
        presenter.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        contentView.onDidChangeText = { [presenter] text in
            presenter.textChanged(text)
        }

        contentView.onDidTapSave = { [presenter] in
            presenter.saveTapped()
        }

        contentView.unitView.onDidSelectItem = { [presenter] index in
            presenter.unitSelected(index: index)
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map(InputPresenter.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: InputPresenter.Route) {
        switch route {
        case .finish(let details):
            contentView.deactivateTextField()
            coordinator.didFinish(inputDetails: details)
        }
    }
}
