//
//  AuthorViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Combine
import UIKit

public protocol AuthorCoordinating: AnyObject {
    func didTapBack()
}

public final class AuthorViewController: UIViewController {

    // MARK: - Properties

    private let presenter: AuthorPresenter
    private let contentView = AuthorView()
    private unowned let coordinator: AuthorCoordinating
    private var cancellables = [AnyCancellable]()

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Lifecycle

    init(presenter: AuthorPresenter, coordinator: AuthorCoordinating) {
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

    override public func loadView() {
        view = contentView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        Task {
            await presenter.viewDidLoad()
        }
    }

    // MARK: - Private methods

    private func setupBinding() {
        contentView.headerView.onTapBack = { [presenter] in
            presenter.backTapped()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map { state in AuthorPresenter.makeProps(from: state) }
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

    private func navigate(by route: AuthorPresenter.Route) {
        switch route {
        case .didTapBack:
            coordinator.didTapBack()
        }
    }
}
