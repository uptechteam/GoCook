//
//  RecipeInstructionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeInstructionView: UIView {

    struct Props: Equatable {
        let title: String
        let description: String
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

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
        setupDescriptionLabel()
        setupStackView()
    }

    private func setupTitleLabel() {
        // TODO: Add typography
        titleLabel.font = FontFamily.RedHatDisplay.medium.font(size: 16)
        titleLabel.textColor = .textMain
    }

    private func setupDescriptionLabel() {
        // TODO: Add typography
        descriptionLabel.numberOfLines = 0
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
        descriptionLabel.render(title: props.description, color: .textSecondary, typography: .bodyTwo)
    }
}
