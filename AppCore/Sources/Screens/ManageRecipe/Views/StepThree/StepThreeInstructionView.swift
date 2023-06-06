//
//  StepThreeInstructionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Helpers
import Library
import UIKit

final class StepThreeInstructionView: UIView {

    struct Props: Equatable {
        let title: String
        let titleColorSource: ColorSource
        let text: String
        let dividerColorSource: ColorSource
        let errorMessage: String
        let isErrorMessageVisible: Bool
        let isDeleteButtonVisible: Bool
    }

    // MARK: - Properties

    private let leadingStackView = UIStackView()
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let dividerView = UIView()
    private let errorLabel = UILabel()
    private let deleteButton = IconButton()
    // callbacks
    var onChangeText: (String) -> Void = { _ in }
    var onTapDeleteButton: () -> Void = { }

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
        setupTitleLabel()
        setupTextView()
        setupToolBar()
        setupDividerView()
        setupErrorLabel()
        setupDeleteButton()
        setupLeadingStackView()
        setupStackView()
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupTextView() {
        textView.font = Typography.subtitleThree.font
        textView.textColor = .textMain
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupToolBar() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textView.inputAccessoryView = keyboardToolbar
    }

    private func setupDividerView() {
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupErrorLabel() {
        errorLabel.textAlignment = .left
    }

    private func setupDeleteButton() {
        deleteButton.set(image: .closeRed)
        deleteButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapDeleteButton() }),
            for: .touchUpInside
        )
    }

    private func setupLeadingStackView() {
        [titleLabel, textView, dividerView, errorLabel].forEach(leadingStackView.addArrangedSubview)
        leadingStackView.axis = .vertical
        leadingStackView.setCustomSpacing(8, after: titleLabel)
        leadingStackView.setCustomSpacing(8, after: dividerView)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [leadingStackView, deleteButton])
        stackView.spacing = 15
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        textView.text = props.text
        updateUI(props: props)
    }

    /// Render passed props except text.
    func updateUI(props: Props) {
        titleLabel.render(title: props.title, color: props.titleColorSource.color, typography: .bodyThree)
        dividerView.backgroundColor = props.dividerColorSource.color
        errorLabel.isHidden = !props.isErrorMessageVisible
        errorLabel.render(title: props.errorMessage, color: .errorMain, typography: .bodyTwo)
        deleteButton.isHidden = !props.isDeleteButtonVisible
    }

    // MARK: - Private methods

    @objc
    private func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}

// MARK: - Delegate

extension StepThreeInstructionView: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let oldText = textView.text ?? ""
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: text)
        guard newText.count <= 10000 else {
            return false
        }

        onChangeText(newText)
        return true
    }
}
