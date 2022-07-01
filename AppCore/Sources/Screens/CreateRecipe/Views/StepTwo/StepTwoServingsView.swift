//
//  StepTwoServingsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class StepTwoServingsView: UIView {

    struct Props: Equatable {
        let amountText: String
        let amountColorSource: ColorSource
        let amountTypography: Typography
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    // callbacks
    var onDidTap: () -> Void = { }

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
        setupTitleLabel()
        setupAmountLabel()
        setupStackView()
    }

    private func setupContentView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    private func setupTitleLabel() {
        titleLabel.render(title: "Number of servings", color: .textMain, typography: .subtitle)
    }

    private func setupAmountLabel() {
        amountLabel.render(typography: .body)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), amountLabel])
        stackView.alignment = .bottom
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        amountLabel.render(
            title: props.amountText,
            color: props.amountColorSource.color,
            typography: props.amountTypography
        )
    }

    // MARK: - Private methods

    @objc
    private func handleTap() {
        onDidTap()
    }
}
