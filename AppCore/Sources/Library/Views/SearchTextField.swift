//
//  SearchTextField.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import Helpers
import UIKit

public final class SearchTextField: UITextField {

    // MARK: - Properties

    private let loopImageView = UIImageView()
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
        setupContentView()
        setupLoopImageView()
    }

    private func setupContentView() {
        backgroundColor = .gray50
        delegate = self
        layer.roundCornersContinuosly(radius: 8)
        leftView = UIView()
        leftViewMode = .always
        addAction(UIAction(handler: { [unowned self] _ in onChangeText(text ?? "") }), for: .editingChanged)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 41)
        ])
    }

    private func setupLoopImageView() {
        loopImageView.image = .search
        addSubview(loopImageView, constraints: [
            loopImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            loopImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 0, y: 0, width: 41, height: bounds.height)
    }
}

// MARK: - UITextFieldDelegate

extension SearchTextField: UITextFieldDelegate {
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
        return newText.count <= AppConstants.Limits.searchQuery
    }
}
