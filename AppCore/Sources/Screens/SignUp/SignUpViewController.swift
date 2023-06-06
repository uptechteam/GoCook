//
//  SignUpViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Combine
import Helpers
import Library
import UIKit

public protocol SignUpCoordinating: AnyObject {
    func didFinishSignUp()
    func didTapLogin()
}

public final class SignUpViewController: UIViewController, ErrorPresentable {

    // MARK: - Properties

    private let presenter: SignUpPresenter
    private let contentView = SignUpView()
    private unowned let coordinator: SignUpCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(presenter: SignUpPresenter, coordinator: SignUpCoordinating) {
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
        title = .signUpTitle
    }

    private func setupBinding() {
        contentView.onTapSkip = { [presenter] in
            presenter.skipTapped()
        }

        contentView.nameInputView.onChangeText = { [presenter] text in
            presenter.nameChanged(text)
        }

        contentView.passwordInputView.onChangeText = { [presenter] text in
            presenter.passwordChagned(text)
        }

        contentView.onTapSignUp = toSyncClosure { [presenter] in
            await presenter.signUpTapped()
        }

        contentView.onTapSignUpWithApple = { [presenter] in
            presenter.signUpWithAppleTapped()
        }

        contentView.onTapHaveAccount = { [presenter] in
            presenter.loginTapped()
        }

        presenter.keyboardHeightChange
            .sink { [contentView] height in
                contentView.updateBottomInset(keyboardHeight: height)
            }
            .store(in: &cancellables)

        let state = presenter.$state
            .removeDuplicates()

        state
            .map(SignUpPresenter.makeProps)
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
            .sink { [unowned self] route in navigate(by: route) }
            .store(in: &cancellables)
    }

    private func show(alert: SignUpPresenter.Alert) {
        switch alert {
        case .notImplemented:
            showNotImplementedAlert()

        case .error(let error):
            show(errorMessage: error.localizedDescription)
        }
    }

    private func navigate(by route: SignUpPresenter.Route) {
        switch route {
        case .login:
            coordinator.didTapLogin()

        case .finish:
            coordinator.didFinishSignUp()
        }
    }
}

// MARK: - Alerts

extension SignUpViewController {
    private func showNotImplementedAlert() {
        let alertController = UIAlertController(
            title: .signUpAlertNotImplementedTitle,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: .signUpAlertActionOk, style: .default))
        present(alertController, animated: true)
    }
}
