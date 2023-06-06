//
//  IngredientCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class IngredientCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {

        // MARK: - Properties

        let id: String
        let name: String
        let nameColorSource: ColorSource
        let nameTypography: Typography
        let amount: String
        let amountColorSource: ColorSource
        let amountTypography: Typography
        let isDeleteImageViewVisible: Bool

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let nameLabel = UILabel()
    private let amountLabel = UILabel()
    private let deleteImageView = IconButton()
    // callbacks
    var onTapName: () -> Void = { }
    var onTapAmount: () -> Void = { }
    var onTapDelete: () -> Void = { }

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
        setupNameLabel()
        setupAmountLabel()
        setupDeleteImageView()
        setupStackView()
    }

    private func setupNameLabel() {
        nameLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNameLabelTap))
        nameLabel.addGestureRecognizer(tapGesture)
    }

    private func setupAmountLabel() {
        amountLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAmountLabelTap))
        amountLabel.addGestureRecognizer(tapGesture)
    }

    private func setupDeleteImageView() {
        deleteImageView.isHidden = true
        deleteImageView.set(image: .closeRed)
        deleteImageView.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapDelete() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), amountLabel, deleteImageView])
        stackView.alignment = .center
        stackView.setCustomSpacing(16, after: amountLabel)
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        nameLabel.render(title: props.name, color: props.nameColorSource.color, typography: props.nameTypography)
        amountLabel.render(title: props.amount, color: props.amountColorSource.color, typography: props.amountTypography)
        deleteImageView.isHidden = !props.isDeleteImageViewVisible
    }

    // MARK: - Private methods

    @objc
    private func handleNameLabelTap() {
        onTapName()
    }

    @objc
    private func handleAmountLabelTap() {
        onTapAmount()
    }
}
