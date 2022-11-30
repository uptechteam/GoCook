//
//  ContentStateView.swift
//  
//
//  Created by Oleksii Andriushchenko on 26.11.2022.
//

import UIKit

/// View is used to render current state of view, it may be loading, empty or error state.
public final class ContentStateView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let isVisible: Bool
        public let isSpinnerVisible: Bool
        public let isTitleVisible: Bool
        public let title: String
        public let isActionButtonVisible: Bool
        public let actionButtonTitle: String

        // MARK: - Lifecycle

        public init(
            isVisible: Bool,
            isSpinnerVisible: Bool,
            isTitleVisible: Bool,
            title: String,
            isActionButtonVisible: Bool,
            actionButtonTitle: String
        ) {
            self.isVisible = isVisible
            self.isSpinnerVisible = isSpinnerVisible
            self.isTitleVisible = isTitleVisible
            self.title = title
            self.isActionButtonVisible = isActionButtonVisible
            self.actionButtonTitle = actionButtonTitle
        }
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
        setupSpinnerView()
        setupSpinnerView()
        setupActionButton()
        setupStackView()
    }

    private func setupSpinnerView() {
        NSLayoutConstraint.activate([
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupActionButton() {
        actionButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapAction() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [spinnerView, titleLabel, actionButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        isHidden = !props.isVisible
        spinnerView.toggle(isAnimating: props.isSpinnerVisible)
        titleLabel.isHidden = !props.isTitleVisible
        titleLabel.render(title: props.title, color: .textDisabled, typography: .body)
        actionButton.isHidden = !props.isActionButtonVisible
        actionButton.setTitle(props.actionButtonTitle)
    }
}
