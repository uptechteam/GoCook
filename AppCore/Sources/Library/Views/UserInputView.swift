//
//  UserInputView.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import Helpers
import UIKit

public final class UserInputView: UIView {

    public enum Props: Equatable {
        case error(message: String)
        case valid
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    public let textField = UITextField()
    private let dividerView = UIView()
    private let errorLabel = UILabel()
    // callbacks
    public var onDidChangeText: (String) -> Void = { _ in }

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
        setupTextField()
        setupDividerView()
        setupStackView()
    }

    private func setupTextField() {
        textField.font = Typography.subtitleThree.font
        textField.textColor = .appBlack
        textField.tintColor = .appBlack
        textField.delegate = self
    }

    private func setupDividerView() {
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textField, dividerView, errorLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(16, after: titleLabel)
        stackView.setCustomSpacing(10, after: textField)
        stackView.setCustomSpacing(8, after: dividerView)
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func configure(title: String) {
        titleLabel.render(title: title, color: .textSecondary, typography: .bodyTwo)
    }

    public func render(props: Props) {
        switch props {
        case .error(let message):
            titleLabel.render(title: titleLabel.text ?? "", color: .errorMain, typography: .bodyTwo)
            dividerView.backgroundColor = .errorMain
            errorLabel.isHidden = false
            errorLabel.render(title: message, color: .errorMain, typography: .bodyTwo)

        case .valid:
            titleLabel.render(title: titleLabel.text ?? "", color: .textSecondary, typography: .bodyTwo)
            dividerView.backgroundColor = .appBlack
            errorLabel.isHidden = true
        }
    }
}

// MARK: - Delegate

extension UserInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text ?? ""
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        guard newText.count <= 80 else {
            return false
        }

        onDidChangeText(newText)
        return true
    }
}
