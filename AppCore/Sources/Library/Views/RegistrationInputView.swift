//
//  RegistrationInputView.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import Helpers
import UIKit

public final class RegistrationInputView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let title: String
        public let titleColorSource: ColorSource
        public let validationViewProps: InputValidationView.Props
        public let dividerColorSource: ColorSource
        public let isDescriptionVisible: Bool
        public let description: String
        public let descriptionColorSource: ColorSource

        // MARK: - Lifecycke

        public init(
            title: String,
            titleColorSource: ColorSource,
            validationViewProps: InputValidationView.Props,
            dividerColorSource: ColorSource,
            isDescriptionVisible: Bool,
            description: String,
            descriptionColorSource: ColorSource
        ) {
            self.title = title
            self.titleColorSource = titleColorSource
            self.validationViewProps = validationViewProps
            self.dividerColorSource = dividerColorSource
            self.isDescriptionVisible = isDescriptionVisible
            self.description = description
            self.descriptionColorSource = descriptionColorSource
        }
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let textFieldStackView = UIStackView()
    public let textField = UITextField()
    private let validationView = InputValidationView()
    private let dividerView = UIView()
    private let descriptionLabel = UILabel()
    // callbacks
    public var onChangeText: (String) -> Void = { _ in }

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
        setupStackView()
        setupTextFieldStackView()
        setupTextField()
        setupDividerView()
        setupDescriptionLabel()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, textFieldStackView, dividerView, descriptionLabel])
        stackView.axis = .vertical
        stackView.setCustomSpacing(16, after: titleLabel)
        stackView.setCustomSpacing(10, after: textFieldStackView)
        stackView.setCustomSpacing(8, after: dividerView)
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupTextFieldStackView() {
        [textField, validationView].forEach(textFieldStackView.addArrangedSubview)
        textFieldStackView.alignment = .center
        textFieldStackView.spacing = 8
    }

    private func setupTextField() {
        textField.delegate = self
        textField.font = Typography.subtitleThree.font
        textField.textColor = .appBlack
    }

    private func setupDividerView() {
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
    }

    // MARK: - Public methods

    public func render(props: Props) {
        titleLabel.render(title: props.title, color: props.titleColorSource.color, typography: .bodyTwo)
        textField.tintColor = props.titleColorSource.color
        validationView.render(props: props.validationViewProps)
        dividerView.backgroundColor = props.dividerColorSource.color
        descriptionLabel.isHidden = !props.isDescriptionVisible
        descriptionLabel.render(
            title: props.description,
            color: props.descriptionColorSource.color,
            typography: .bodyTwo
        )
    }
}

// MARK: - Delegate

extension RegistrationInputView: UITextFieldDelegate {
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

        onChangeText(newText)
        return true
    }
}
