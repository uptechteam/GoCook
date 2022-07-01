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
        let isNextButtonVisible: Bool
        let isFinishButtonVisible: Bool
        let isLoaderVisible: Bool
    }

    // MARK: - Properties

    private let dividerView = UIView()
    private let backButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .primaryPressed),
            isBackgroundVisible: false
        )
    )
    private let titleLabel = UILabel()
    private let nextButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .primaryPressed),
            imagePosition: .right,
            isBackgroundVisible: false
        )
    )
    private let finishButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .primaryPressed),
            isBackgroundVisible: false
        )
    )
    private let spinnerView = SpinnerView()
    // callbacks
    var onDidTapBack: () -> Void = { }
    var onDidTapNext: () -> Void = { }
    var onDidTapFinish: () -> Void = { }

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
        setupFinishButton()
        setupSpinnerView()
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
        backButton.setTitle(.createRecipeNavigationBack)
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
        nextButton.setTitle(.createRecipeNavigationNext)
        nextButton.setImage(.arrowForwardGreen)
        nextButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapNext() }), for: .touchUpInside)
    }

    private func setupFinishButton() {
        finishButton.setTitle(.createRecipeNavigationFinish)
        finishButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapFinish() }),
            for: .touchUpInside
        )
    }

    private func setupSpinnerView() {
        NSLayoutConstraint.activate([
            spinnerView.widthAnchor.constraint(equalToConstant: 20),
            spinnerView.heightAnchor.constraint(equalTo: spinnerView.widthAnchor)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel, nextButton, finishButton, spinnerView])
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
        nextButton.isHidden = !props.isNextButtonVisible
        finishButton.isHidden = !props.isFinishButtonVisible
        spinnerView.toggle(isAnimating: props.isLoaderVisible)
    }
}
