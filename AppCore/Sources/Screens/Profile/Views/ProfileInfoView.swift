//
//  ProfileInfoView.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Library
import UIKit

final class ProfileInfoView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let description: String
        let isAddRecipeButtonVisible: Bool
    }

    // MARK: - Properties

    private let descriptionLabel = UILabel()
    private let addRecipeButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    // callbacks
    var onDidTapAddRecipe: () -> Void = { }

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
        setupDescriptionLabel()
        setupAddRecipeButton()
        setupStackView()
    }

    private func setupDescriptionLabel() {
        descriptionLabel.font = FontFamily.RedHatDisplay.regular.font(size: 16)
        descriptionLabel.textColor = .textDisabled
        descriptionLabel.text = .profileEmptyContentTitle
    }

    private func setupAddRecipeButton() {
        addRecipeButton.setTitle(.profileEmptyContentButtonTitle)
        addRecipeButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapAddRecipe() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [descriptionLabel, addRecipeButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView, constraints: [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        descriptionLabel.text = props.description
        addRecipeButton.isHidden = !props.isAddRecipeButtonVisible
    }
}
