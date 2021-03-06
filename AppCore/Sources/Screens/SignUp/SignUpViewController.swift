//
//  SignUpViewController.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Combine
import Library
import UIKit

public protocol SignUpCoordinating: AnyObject {
    func didFinishSignUp()
    func didTapLogin()
}

public final class SignUpViewController: UIViewController, ErrorPresentable {

    // MARK: - Properties

    private let store: Store
    private let actionCreator: ActionCreator
    private let contentView = SignUpView()
    private unowned let coordinator: SignUpCoordinating
    private var cancellables = [AnyCancellable]()

    // MARK: - Lifecycle

    public init(
        store: Store,
        actionCreator: ActionCreator,
        coordinator: SignUpCoordinating
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
        title = .signUpTitle
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

        contentView.onDidTapSignUp = { [store] in
            store.dispatch(action: .signUpTapped)
        }

        contentView.onDidTapSignUpWithApple = { [store] in
            store.dispatch(action: .signUpWithAppleTapped)
        }

        contentView.onDidTapHaveAccount = { [store] in
            store.dispatch(action: .loginTapped)
        }

        let state = store.$state.removeDuplicates()
            .subscribe(on: DispatchQueue.main)

        state
            .map(SignUpViewController.makeProps)
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

    private func navigate(by route: Route) {
        switch route {
        case .login:
            coordinator.didTapLogin()

        case .finish:
            coordinator.didFinishSignUp()
        }
    }
}
