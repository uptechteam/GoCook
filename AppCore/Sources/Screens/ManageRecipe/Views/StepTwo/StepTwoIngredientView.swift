//
//  IngredientCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class StepTwoIngredientView: UIView {

    struct Props: Equatable {
        let name: String
        let nameColor: ColorSource
        let nameTypography: Typography
        let amount: String
        let amountColor: ColorSource
        let amountTypography: Typography
        let isDeleteImageViewVisible: Bool
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
        setupStackView()
        setupNameLabel()
        setupAmountLabel()
        setupDeleteImageView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), amountLabel, deleteImageView])
        stackView.alignment = .center
        stackView.setCustomSpacing(16, after: amountLabel)
        addSubview(stackView, withEdgeInsets: .zero)
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

    // MARK: - Public methods

    func render(props: Props) {
        nameLabel.render(title: props.name, color: props.nameColor.color, typography: props.nameTypography)
        amountLabel.render(title: props.amount, color: props.amountColor.color, typography: props.amountTypography)
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
