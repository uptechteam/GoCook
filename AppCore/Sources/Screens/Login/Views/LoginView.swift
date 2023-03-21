//
//  LoginView.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Helpers
import Library
import UIKit

final class LoginView: UIView {

    struct Props: Equatable {
        let isNavigationBarVisible: Bool
        let backgroundImageSource: ImageSource
        let isSkipButtonVisible: Bool
        let title: String
        let nameInputViewProps: RegistrationInputView.Props
        let passwordInputViewProps: RegistrationInputView.Props
        let isLoginButtonEnabled: Bool
        let isLoading: Bool
    }

    // MARK: - Properties

    private let dividerView = UIView()
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
    private var scrollViewTopConstraint: NSLayoutConstraint!
    private var scrollViewSafeAreaTopConstraint: NSLayoutConstraint!
    private var stackViewTopConstraint: NSLayoutConstraint!
    private var stackViewHeightConstraint: NSLayoutConstraint!
    // callbacks
    var onTapSkip: () -> Void = { }
    var onTapLogin: () -> Void = { }
    var onTapLoginWithApple: () -> Void = { }
    var onTapNew: () -> Void = { }

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
        let safeAreaVerticalInsets = safeAreaInsets.top + safeAreaInsets.bottom
        let height = frame.height - stackViewTopConstraint.constant - 8 - safeAreaVerticalInsets
        stackViewHeightConstraint.constant = height
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupDividerView()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        addGestureRecognizer(tapGesture)
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

    private func setupBackgroundImageView() {
        scrollViewTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: topAnchor)
        scrollViewSafeAreaTopConstraint = backgroundImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        addSubview(backgroundImageView, constraints: [
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupPasswordInputView() {
        passwordInputView.textField.isSecureTextEntry = true
        passwordInputView.textField.textContentType = .oneTimeCode
    }

    private func setupLoginButton() {
        loginButton.setTitle(.loginLogin)
        loginButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapLogin() }), for: .touchUpInside)
    }

    private func setupOrLabel() {
        orLabel.render(title: .loginOr, color: .textSecondary, typography: .subtitleTwo)
        orLabel.textAlignment = .center
    }

    private func setupLoginWithAppleButton() {
        loginWithAppleButton.setTitle(.loginLoginWithApple)
        loginWithAppleButton.setImage(.apple)
        loginWithAppleButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapLoginWithApple() }),
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
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 72)
        scrollView.addSubview(stackView, constraints: [
            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8)
        ])
        stackViewHeightConstraint = stackView.heightAnchor.constraint(equalToConstant: 0)
            .prioritised(as: .defaultLow)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48),
            stackViewHeightConstraint
        ])
    }

    private func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .always
        addSubview(scrollView, constraints: [
            scrollView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupSkipButton() {
        skipButton.setTitle(.loginSkip)
        skipButton.setImage(.arrowForward)
        skipButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapSkip() }), for: .touchUpInside)
        skipButton.layer.addShadow(opacitiy: 0.1, radius: 4, offset: CGSize(width: 0, height: 4))
        addSubview(skipButton, constraints: [
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        renderTopViews(isNavigationBarVisible: props.isNavigationBarVisible)
        backgroundImageView.set(props.backgroundImageSource)
        titleLabel.render(title: props.title, color: .textMain, typography: .headerOne)
        loginButton.toggleLoading(on: props.isLoading)
        nameInputView.render(props: props.nameInputViewProps)
        passwordInputView.render(props: props.passwordInputViewProps)
        loginButton.isEnabled = props.isLoginButtonEnabled
        skipButton.isHidden = !props.isSkipButtonVisible
    }

    func updateBottomInset(keyboardHeight: CGFloat) {
        scrollView.contentInset.bottom = keyboardHeight
        layoutSubviews()
    }

    // MARK: - Private methods

    private func renderTopViews(isNavigationBarVisible: Bool) {
        dividerView.isHidden = !isNavigationBarVisible
        scrollViewTopConstraint.isActive = !isNavigationBarVisible
        scrollViewSafeAreaTopConstraint.isActive = isNavigationBarVisible
        stackViewTopConstraint.constant = isNavigationBarVisible ? 93 : 72
        titleLabel.textAlignment = isNavigationBarVisible ? .center : .natural
    }

    @objc
    private func handleTap() {
        endEditing(true)
    }

    @objc
    private func handleNewTap() {
        onTapNew()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LoginView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else {
            return false
        }

        return !(view is UIControl)
    }
}
