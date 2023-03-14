//
//  UserInputView.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import Helpers
import UIKit

public final class UserInputView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let title: String
        public let titleColorSource: ColorSource
        public let dividerColorSource: ColorSource
        public let errorMessage: String
        public let isErrorMessageVisible: Bool

        // MARK: - Lifecycke

        public init(
            title: String,
            titleColorSource: ColorSource,
            dividerColorSource: ColorSource,
            errorMessage: String,
            isErrorMessageVisible: Bool
        ) {
            self.title = title
            self.titleColorSource = titleColorSource
            self.dividerColorSource = dividerColorSource
            self.errorMessage = errorMessage
            self.isErrorMessageVisible = isErrorMessageVisible
        }
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

    public func render(props: Props) {
        titleLabel.render(title: props.title, color: props.titleColorSource.color, typography: .bodyTwo)
        dividerView.backgroundColor = props.dividerColorSource.color
        errorLabel.isHidden = !props.isErrorMessageVisible
        errorLabel.render(title: props.errorMessage, color: .errorMain, typography: .bodyTwo)
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
