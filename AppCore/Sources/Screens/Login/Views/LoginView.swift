//
//  LoginView.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Library
import UIKit

final class LoginView: UIView {

    struct Props: Equatable {
        let isLoading: Bool
        let nameInputViewProps: RegistrationInputView.Props
        let passwordInputViewProps: RegistrationInputView.Props
    }

    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let backgroundImageView = UIImageView()
    private let skipButton = Button(
        config: ButtonConfig(buttonSize: .small, colorConfig: .white, imagePosition: .right)
    )
    private let titleLabel = UILabel()
    let nameInputView = RegistrationInputView()
    let passwordInputView = RegistrationInputView()
    private let loginButton = Button()
    private let orLabel = UILabel()
    private let loginWithAppleButton = Button(
        config: ButtonConfig(colorConfig: .secondary, isBackgroundVisible: false, isBorderVisible: true)
    )
    private let newLabel = UILabel()
    private var stackViewHeightConstraint: NSLayoutConstraint!
    // callbacks
    var onDidTapSkip: () -> Void = { }
    var onDidTapLogin: () -> Void = { }
    var onDidTapLoginWithApple: () -> Void = { }
    var onDidTapNew: () -> Void = { }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = frame.height - 80 - scrollView.safeAreaInsets.top - scrollView.safeAreaInsets.bottom
        stackViewHeightConstraint.constant = height
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupBackgroundImageView()
        setupTitleLabel()
        setupPasswordInputView()
        setupLoginButton()
        setupOrLabel()
        setupLoginWithAppleButton()
        setupNewLabel()
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
        titleLabel.render(title: .loginTitle, color: .textMain, typography: .headerOne)
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupPasswordInputView() {
        passwordInputView.textField.isSecureTextEntry = true
        passwordInputView.textField.textContentType = .oneTimeCode
    }

    private func setupLoginButton() {
        loginButton.setTitle(.loginLogin)
        loginButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapLogin() }), for: .touchUpInside)
    }

    private func setupOrLabel() {
        orLabel.render(title: .loginOr, color: .textSecondary, typography: .subtitleTwo)
        orLabel.textAlignment = .center
    }

    private func setupLoginWithAppleButton() {
        loginWithAppleButton.setTitle(.loginLoginWithApple)
        loginWithAppleButton.setImage(.apple)
        loginWithAppleButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapLoginWithApple() }),
            for: .touchUpInside
        )
    }

    private func setupNewLabel() {
        let attributedText = NSMutableAttributedString()
        attributedText.append(
            NSAttributedString(
                string: .loginNewFirst,
                attributes: [
                    .font: FontFamily.RedHatDisplay.medium.font(size: 14),
                    .foregroundColor: UIColor.textSecondary
                ]
            )
        )
        attributedText.append(
            NSAttributedString(
                string: .loginNewSecond,
                attributes: [
                    .font: FontFamily.RedHatDisplay.regular.font(size: 14),
                    .foregroundColor: UIColor.primaryMain
                ]
            )
        )
        newLabel.attributedText = attributedText
        newLabel.textAlignment = .center
        newLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNewTap))
        newLabel.addGestureRecognizer(tapGesture)
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                UIView(),
                nameInputView,
                passwordInputView,
                loginButton,
                orLabel,
                loginWithAppleButton,
                newLabel
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.setCustomSpacing(24, after: nameInputView)
        stackView.setCustomSpacing(24, after: passwordInputView)
        scrollView.addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 72, left: 24, bottom: 8, right: 24)
        )
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 0)
            .prioritised(as: .defaultLow)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            stackViewHeightConstraint
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
        skipButton.setTitle(.loginSkip)
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
        loginButton.toggleLoading(on: props.isLoading)
        nameInputView.render(props: props.nameInputViewProps)
        passwordInputView.render(props: props.passwordInputViewProps)
    }

    // MARK: - Private methods

    @objc
    private func handleNewTap() {
        onDidTapNew()
    }
}
