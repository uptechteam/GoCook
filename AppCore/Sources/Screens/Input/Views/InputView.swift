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
        let text: String
        let placeholder: String
        let keyboardType: KeyboardType
        let unitViewProps: InputUnitView.Props

        enum KeyboardType: Equatable {
            case defaultType
            case numpadPad
        }
    }

    // MARK: - Properties

    private let containerView = UIView()
    /// This view is used to show white background below keyboard, needed when keyboard type is changing.
    private let bottomBackgroundView = UIView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let saveButton = Button(config: ButtonConfig(buttonSize: .medium, colorConfig: .secondary))
    let unitView = InputUnitView()
    private var bottomConstraint: NSLayoutConstraint!
    private var isFirstLayoutCompleted = false
    // callbacks
    var onChangeText: (String) -> Void = { _ in }
    var onTapSave: () -> Void = { }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        isFirstLayoutCompleted = true
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupContainerView()
        setupBottomBackgroundView()
        setupStackView()
        setupTextField()
        setupSaveButton()
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

    private func setupTextField() {
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.font = Typography.headerThree.font
        textField.spellCheckingType = .no
        textField.textColor = .textMain
        textField.tintColor = .primaryMain
    }

    private func setupSaveButton() {
        saveButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapSave() }),
            for: .touchUpInside
        )
        saveButton.setTitle("Save")
    }

    private func setupUnitView() {
        containerView.addSubview(unitView, constraints: [
            unitView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 91),
            unitView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .textMain, typography: .subtitleTwo)
        textField.text = props.text
        textField.attributedPlaceholder = NSAttributedString(
            string: props.placeholder,
            attributes: Typography.headerThree.getAttributes(color: .textDisabled)
        )
        setKeyboardType(to: props.keyboardType)
        unitView.render(props: props.unitViewProps)
    }

    func activateTextField() {
        textField.becomeFirstResponder()
    }

    func deactivateTextField() {
        textField.resignFirstResponder()
    }

    func updateBottomInset(keyboardHeight: CGFloat) {
        bottomConstraint.constant = -(keyboardHeight)
        guard isFirstLayoutCompleted else {
            return
        }

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Private methods

    private func setKeyboardType(to type: Props.KeyboardType) {
        switch type {
        case .defaultType:
            textField.keyboardType = .default

        case .numpadPad:
            textField.keyboardType = .numberPad
        }

        textField.reloadInputViews()
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

        onChangeText(newText)
        return false
    }
}
