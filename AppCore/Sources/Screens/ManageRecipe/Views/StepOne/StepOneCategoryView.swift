//
//  CategoryCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import Library
import UIKit

final class StepOneCategoryView: UIView {

    struct Props: Equatable {
        let name: String
        let nameColorSource: ColorSource
        let checkmarkImageSource: ImageSource
    }

    // MARK: - Properties

    private let nameLabel = UILabel()
    private let checkmarkButton = IconButton()
    // callbacks
    var onTapCheckmark: () -> Void = { }

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
        setupCheckmarkButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, UIView(), checkmarkButton])
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupCheckmarkButton() {
        checkmarkButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onTapCheckmark() }),
            for: .touchUpInside
        )
        checkmarkButton.set(image: .emptyCheckbox)
    }

    // MARK: - Public methods

    func render(props: Props) {
        nameLabel.render(title: props.name, color: props.nameColorSource.color, typography: .subtitleThree)
        checkmarkButton.set(image: props.checkmarkImageSource.image)
    }
}
