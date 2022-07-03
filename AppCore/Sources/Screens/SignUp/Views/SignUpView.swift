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
        config: ButtonConfig(buttonSize: .small, colorConfig: .white, imagePosition: .right)
    )
    private let titleLabel = UILabel()
    let nameInputView = UserInputView()
    let passwordInputView = UserInputView()
    private let passwordDescriptionLabel = UILabel()
    private let signUpButton = Button()
    private let orLabel = UILabel()
    private let signUpWithAppleButton = Button(
        config: ButtonConfig(colorConfig: .secondary, isBackgroundVisible: false, isBorderVisible: true)
    )
    private let haveAccountLabel = UILabel()
    // callbacks
    var onDidTapSkip: () -> Void = { }
    var onDidTapSignUp: () -> Void = { }
    var onDidTapSignUpWithApple: () -> Void = { }
    var onDidTapHaveAccount: () -> Void = { }

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
        setupPasswordInputView()
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
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupPasswordInputView() {
        passwordInputView.textField.isSecureTextEntry = true
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
        signUpWithAppleButton.setImage(.apple)
        signUpWithAppleButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapSignUpWithApple() }),
            for: .touchUpInside
        )
    }

    private func setupHaveAccountLabel() {
        let attributedText = NSMutableAttributedString()
        attributedText.append(
            NSAttributedString(
                string: .signUpHaveAnAccountFirst,
                attributes: [
                    .font: FontFamily.RedHatDisplay.medium.font(size: 14),
                    .foregroundColor: UIColor.textSecondary
                ]
            )
        )
        attributedText.append(
            NSAttributedString(
                string: .signUpHaveAnAccountSecond,
                attributes: [
                    .font: FontFamily.RedHatDisplay.regular.font(size: 14),
                    .foregroundColor: UIColor.primaryMain
                ]
            )
        )
        haveAccountLabel.attributedText = attributedText
        haveAccountLabel.textAlignment = .center
        haveAccountLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHaveAccountTap))
        haveAccountLabel.addGestureRecognizer(tapGesture)
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                UIView(),
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
            withEdgeInsets: UIEdgeInsets(top: 72, left: 24, bottom: 8, right: 24)
        )
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .always
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

    // MARK: - Private methods

    @objc
    private func handleHaveAccountTap() {
        onDidTapHaveAccount()
    }
}
