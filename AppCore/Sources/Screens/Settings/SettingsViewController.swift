//
//  SettingsViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Combine
import Helpers
import UIKit

public protocol SettingsCoordinating: AnyObject {
    func didLogout()
}

public final class SettingsViewController: UIViewController {

    // MARK: - Properties

    private let presenter: SettingsPresenter
    private let contentView = SettingsView()
    private unowned let coordinator: SettingsCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: SettingsPresenter, coordinator: SettingsCoordinating) {
        self.presenter = presenter
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
        navigationItem.title = .settingsTitle
    }

    private func setupBinding() {
        contentView.onTapLogout = toSyncClosure { [presenter] in
            await presenter.logoutTapped()
        }

        let state = presenter.$state
            .removeDuplicates()

        state
            .map(SettingsPresenter.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func navigate(by route: SettingsPresenter.Route) {
        switch route {
        case .logout:
            coordinator.didLogout()
        }
    }
}
