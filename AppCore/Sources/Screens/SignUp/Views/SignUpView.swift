//
//  SignUpView.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Library
import UIKit

final class SignUpView: UIView {

    struct Props: Equatable {
        let nameInputViewProps: UserInputView.Props
        let passwordInputViewProps: UserInputView.Props
    }

    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let backgroundImageView = UIImageView()
    private let skipButton = Button(
        config: ButtonConfig(
            buttonSize: .small,
            colorConfig: ColorConfig(main: .secondaryMain, secondary: .secondaryPressed),
            imagePosition: .right,
            isBackgroundVisible: false,
            isBorderVisible: true
        )
    )
    private let titleLabel = UILabel()
    let nameInputView = UserInputView()
    let passwordInputView = UserInputView()
    private let passwordDescriptionLabel = UILabel()
    private let signUpButton = Button()
    private let orLabel = UILabel()
    private let signUpWithAppleButton = Button(
        config: ButtonConfig(
            colorConfig: .init(main: .secondaryMain, secondary: .secondaryPressed),
            isBackgroundVisible: false,
            isBorderVisible: true
        )
    )
    private let haveAccountLabel = UILabel()
    // callbacks
    var onDidTapSkip: () -> Void = { }
    var onDidTapSignUp: () -> Void = { }
    var onDidTapSignUpWithApple: () -> Void = { }

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
        setupBackgroundImageView()
        setupTitleLabel()
        setupPasswordDescriptionLabel()
        setupSignUpButton()
        setupOrLabel()
        setupSignUpWithAppleButton()
        setupHaveAccountLabel()
        setupStackView()
        setupScrollView()
        setupSkipButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupBackgroundImageView() {
        backgroundImageView.image = .registrationBackground
        addSubview(backgroundImageView, constraints: [
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.render(title: .signUpTitle, color: .textMain, typography: .headerOne)
        titleLabel.numberOfLines = 0
    }

    private func setupPasswordDescriptionLabel() {
        passwordDescriptionLabel.font = FontFamily.RedHatDisplay.regular.font(size: 14)
        passwordDescriptionLabel.textColor = .textSecondary
        passwordDescriptionLabel.text = .signUpPasswordDescription
        passwordDescriptionLabel.numberOfLines = 0
    }

    private func setupSignUpButton() {
        signUpButton.setTitle(.signUpSignUp)
        signUpButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapSignUp() }), for: .touchUpInside)
    }

    private func setupOrLabel() {
        orLabel.render(title: .signUpOr, color: .textSecondary, typography: .subtitleTwo)
        orLabel.textAlignment = .center
    }

    private func setupSignUpWithAppleButton() {
        signUpWithAppleButton.setTitle(.signUpSignUpWithApple)
        signUpWithAppleButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapSignUpWithApple() }),
            for: .touchUpInside
        )
    }

    private func setupHaveAccountLabel() {
        haveAccountLabel.render(title: .signUpHaveAnAccount, color: .textSecondary, typography: .subtitleTwo)
        haveAccountLabel.textAlignment = .center
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                nameInputView,
                passwordInputView,
                passwordDescriptionLabel,
                signUpButton,
                orLabel,
                signUpWithAppleButton,
                haveAccountLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(74, after: titleLabel)
        stackView.setCustomSpacing(4, after: nameInputView)
        stackView.setCustomSpacing(-12, after: passwordInputView)
        stackView.setCustomSpacing(24, after: passwordDescriptionLabel)
        scrollView.addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 72, left: 24, bottom: 8, right: 24),
            isSafeAreaRequired: true
        )
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupScrollView() {
        addSubview(scrollView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupSkipButton() {
        skipButton.setTitle(.signUpSkip)
        skipButton.setImage(.arrowForward)
        skipButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapSkip() }), for: .touchUpInside)
        skipButton.layer.addShadow(opacitiy: 0.1, radius: 4, offset: CGSize(width: 0, height: 4))
        addSubview(skipButton, constraints: [
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        nameInputView.render(props: props.nameInputViewProps)
        passwordInputView.render(props: props.passwordInputViewProps)
    }
}
