//
//  CategoryCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class CategoryCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {

        // MARK: - Properties

        let name: String
        let nameColorSource: ColorSource
        let checkmarkImageSource: ImageSource

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }
    }

    // MARK: - Properties

    private let nameLabel = UILabel()
    private let checkmarkButton = IconButton()
    // callbacks
    var onDidTapCheckmark: () -> Void = { }

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
        setupCheckmarkButton()
        setupStackView()
    }

    private func setupCheckmarkButton() {
        checkmarkButton.set(image: .emptyCheckbox)
        checkmarkButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapCheckmark() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), checkmarkButton])
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        nameLabel.render(title: props.name, color: props.nameColorSource.color, typography: .subtitleThree)
        checkmarkButton.set(image: props.checkmarkImageSource.image)
    }
}
