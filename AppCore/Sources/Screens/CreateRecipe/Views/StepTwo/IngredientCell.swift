//
//  IngredientCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Library
import UIKit

final class IngredientCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {

        // MARK: - Properties

        let id: String
        let isDeleteImageViewVisible: Bool

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let nameTextField = UITextField()
    private let amountTextField = UITextField()
    private let deleteImageView = IconButton()
    // callbacks
    var onDidTapDelete: () -> Void = { }

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
        setupNameTextField()
        setupAmountStackView()
        setupDeleteImageView()
        setupStackView()
    }

    private func setupNameTextField() {
        nameTextField.placeholder = "Ingredient name"
    }

    private func setupAmountStackView() {
        amountTextField.placeholder = "Enter amount"
    }

    private func setupDeleteImageView() {
        deleteImageView.isHidden = true
        deleteImageView.set(image: .closeRed)
        deleteImageView.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapDelete() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, UIView(), amountTextField, deleteImageView])
        stackView.alignment = .center
        stackView.setCustomSpacing(16, after: amountTextField)
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        deleteImageView.isHidden = !props.isDeleteImageViewVisible
    }
}
