//
//  CreateRecipeStepsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Library
import UIKit

final class CreateRecipeStepsView: UIView {

    struct Props: Equatable {
        let title: String
    }

    // MARK: - Properties

    private let dividerView = UIView()
    let backButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .primaryPressed),
            isBackgroundVisible: false
        )
    )
    private let titleLabel = UILabel()
    let nextButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .primaryPressed),
            imagePosition: .right,
            isBackgroundVisible: false
        )
    )
    // callbacks
    var onDidTapBack: () -> Void = { }
    var onDidTapNext: () -> Void = { }

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
        setupDivider()
        setupBackButton()
        setupTitleLabel()
        setupNextButton()
        setupStackView()
    }

    private func setupDivider() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupBackButton() {
        backButton.setTitle("Back")
        backButton.setImage(.arrowBack)
        backButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapBack() }), for: .touchUpInside)
    }

    private func setupTitleLabel() {
        titleLabel.render(typography: .buttonLarge)
        titleLabel.textColor = .textMain
        titleLabel.textAlignment = .center
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func setupNextButton() {
        nextButton.setTitle("Next")
        nextButton.setImage(.arrowForward)
        nextButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapNext() }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel, nextButton])
        stackView.alignment = .center
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
    }
}
