//
//  LoginViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Combine
import Library
import UIKit

public protocol LoginCoordinating: AnyObject {
    func didFinishLogin()
    func didTapSignUp()
}

public final class LoginViewController: UIViewController, ErrorPresentable {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = LoginView()
    private unowned let coordinator: LoginCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: LoginCoordinating
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
        title = .loginTitle
    }

    private func setupBinding() {
        contentView.onDidTapSkip = { [store] in
            store.dispatch(action: .skipTapped)
        }

        contentView.nameInputView.onDidChangeText = { [store] text in
            store.dispatch(action: .nameChanged(text))
        }

        contentView.passwordInputView.onDidChangeText = { [store] text in
            store.dispatch(action: .passwordChanged(text))
        }

        contentView.onDidTapLogin = { [store] in
            store.dispatch(action: .loginTapped)
        }

        contentView.onDidTapLoginWithApple = { [store] in
            store.dispatch(action: .loginWithAppleTapped)
        }

        contentView.onDidTapNew = { [store] in
            store.dispatch(action: .signUp)
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(LoginViewController.makeProps)
            .sink { [contentView] props in
                contentView.render(props: props)
            }
            .store(in: &cancellables)

        state.compactMap(\.alert).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] alert in show(alert: alert) }
            .store(in: &cancellables)

        state.compactMap(\.route).removeDuplicates()
            .map(\.value)
            .sink { [unowned self] route in naviagte(by: route) }
            .store(in: &cancellables)
    }

    private func show(alert: Alert) {
        switch alert {
        case .notImplemented:
            let alertController = UIAlertController(title: "Not implemented yet", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alertController, animated: true)

        case .error(let error):
            show(errorMessage: error.localizedDescription)
        }
    }

    private func naviagte(by route: Route) {
        switch route {
        case .finish:
            coordinator.didFinishLogin()

        case .signUp:
            coordinator.didTapSignUp()
        }
    }
}
