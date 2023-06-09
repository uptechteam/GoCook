//
//  LoginViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Combine
import Helpers
import Library
import UIKit

public protocol LoginCoordinating: AnyObject {
    func didFinishLogin()
    func didTapSignUp()
}

public final class LoginViewController: UIViewController, ErrorPresentable {

    // MARK: - Properties

    private let presenter: LoginPresenter
    private let contentView = LoginView()
    private unowned let coordinator: LoginCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: LoginPresenter, coordinator: LoginCoordinating) {
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
        title = .loginTitle
    }

    private func setupBinding() {
        contentView.onTapSkip = { [presenter] in
            presenter.skipTapped()
        }

        contentView.nameInputView.onChangeText = { [presenter] text in
            presenter.nameChanged(text)
        }

        contentView.passwordInputView.onChangeText = { [presenter] text in
            presenter.passwordChanged(text)
        }

        contentView.onTapLogin = toSyncClosure { [presenter] in
            await presenter.loginTapped()
        }

        contentView.onTapLoginWithApple = { [presenter] in
            presenter.loginWithAppleTapped()
        }

        contentView.onTapNew = { [presenter] in
            presenter.signUpTapped()
        }

        presenter.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        let state = presenter.$state
            .removeDuplicates()

        state
            .map(LoginPresenter.makeProps)
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

    private func show(alert: LoginPresenter.Alert) {
        switch alert {
        case .notImplemented:
            showNotImplementedAlert()

        case .error(let message):
            show(errorMessage: message)
        }
    }

    private func naviagte(by route: LoginPresenter.Route) {
        switch route {
        case .didFinish:
            coordinator.didFinishLogin()

        case .didTapSignUp:
            coordinator.didTapSignUp()
        }
    }
}

// MARK: - Alerts

extension LoginViewController {
    private func showNotImplementedAlert() {
        let alertController = UIAlertController(
            title: .loginAlertNotImplementedTitle,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: .loginAlertActionOk, style: .default))
        present(alertController, animated: true)
    }
}
