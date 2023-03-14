//
//  ContentStateView.swift
//  
//
//  Created by Oleksii Andriushchenko on 26.11.2022.
//

import UIKit

/// View is used to render current state of view, it may be loading, empty or error state.
public final class ContentStateView: UIView {

    public enum Props: Equatable {
        case hidden
        case loading
        case message(title: String, buttonTitle: String?)
    }

    // MARK: - Properties

    private let spinnerView = SpinnerView(circleColor: .secondaryMain)
    private let titleLabel = UILabel()
    private let actionButton = Button(config: ButtonConfig(colorConfig: .primary, isBackgroundVisible: false))
    // callbacks
    public var onTapAction: () -> Void = { }

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
        setupStackView()
        setupSpinnerView()
        setupTitleLabel()
        setupActionButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [spinnerView, titleLabel, actionButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func setupSpinnerView() {
        NSLayoutConstraint.activate([
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    }

    private func setupActionButton() {
        actionButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapAction() }), for: .touchUpInside)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        switch props {
        case .hidden:
            isHidden = true
            spinnerView.toggle(isAnimating: false)

        case .loading:
            isHidden = false
            spinnerView.toggle(isAnimating: true)
            titleLabel.isHidden = true
            actionButton.isHidden = true

        case let .message(title, buttonTitle):
            isHidden = false
            titleLabel.isHidden = false
            titleLabel.render(title: title, color: .textDisabled, typography: .body)
            spinnerView.toggle(isAnimating: false)
            actionButton.isHidden = buttonTitle == nil
            actionButton.setTitle(buttonTitle ?? "")
        }
    }
}
