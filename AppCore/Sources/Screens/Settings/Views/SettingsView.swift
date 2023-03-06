//
//  SettingsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Library
import UIKit

final class SettingsView: UIView {

    struct Props: Equatable {
        var isLoading: Bool
    }

    // MARK: - Properties

    private let dividerView = UIView()
    private let logoutButton = Button(
        config: ButtonConfig(colorConfig: .error, isBackgroundVisible: false, isBorderVisible: true)
    )
    // callbacks
    var onDidTapLogout: () -> Void = { }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupDividerView()
        setupLogoutButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupDividerView() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupLogoutButton() {
        logoutButton.setTitle(.settingsLogout)
        logoutButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapLogout() }), for: .touchUpInside)
        addSubview(logoutButton, constraints: [
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            logoutButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        logoutButton.toggleLoading(on: props.isLoading)
    }
}
