//
//  InputView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Library
import UIKit

final class InputView: UIView {

    struct Props: Equatable {
        let title: String
        let placeholder: String
        let unitViewProps: InputUnitView.Props
    }

    // MARK: - Properties

    private let containerView = UIView()
    /// This view is used to show white background below keyboard, needed when keyboard type is changing.
    private let bottomBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let saveButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .textMain, secondary: .textSecondary)
        )
    )
    let unitView = InputUnitView()
    private var bottomConstraint: NSLayoutConstraint!
    // callbacks
    var onDidChangeText: (String) -> Void = { _ in }
    var onDidTapSave: () -> Void = { }

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
        setupContainerView()
        setupBottomBackgroundView()
        setupTitleLabel()
        setupTextField()
        setupSaveButton()
        setupStackView()
        setupUnitView()
    }

    private func setupContentView() {
        backgroundColor = .appBlack.withAlphaComponent(0.2)
    }

    private func setupContainerView() {
        containerView.backgroundColor = .appWhite
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        addSubview(containerView, constraints: [
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConstraint
        ])
    }

    private func setupBottomBackgroundView() {
        bottomBackgroundView.backgroundColor = .appWhite
        addSubview(bottomBackgroundView, constraints: [
            bottomBackgroundView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        bringSubviewToFront(containerView)
    }

    private func setupTitleLabel() {
        titleLabel.render(typography: .subtitleTwo)
        titleLabel.textColor = .textMain
    }

    private func setupTextField() {
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.delegate = self
        textField.font = FontFamily.RedHatDisplay.regular.font(size: 30)
        textField.textColor = .textMain
    }

    private func setupSaveButton() {
        saveButton.setTitle("Save")
        saveButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapSave() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, saveButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(40, after: titleLabel)
        stackView.setCustomSpacing(32, after: textField)
        containerView.addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24))
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func setupUnitView() {
        containerView.addSubview(unitView, constraints: [
            unitView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 91),
            unitView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
        textField.attributedPlaceholder = NSAttributedString(
            string: props.placeholder,
            attributes: [
                .font: FontFamily.RedHatDisplay.regular.font(size: 30),
                .foregroundColor: UIColor.textDisabled
            ]
        )
        unitView.render(props: props.unitViewProps)
    }

    func activateTextField() {
        textField.becomeFirstResponder()
    }

    func updateBottomInset(keyboardHeight: CGFloat) {
        bottomConstraint.constant = -(keyboardHeight)
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}

// MARK: - Delegates

extension InputView: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text ?? ""
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        guard newText.count <= 30 else {
            return false
        }

        onDidChangeText(newText)
        return true
    }
}
