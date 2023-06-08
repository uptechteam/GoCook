//
//  RecipeInstructionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public final class RecipeInstructionView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let title: String
        public let description: String

        // MARK: - Lifecycle

        public init(title: String, description: String) {
            self.title = title
            self.description = description
        }
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
        setupStackView()
        setupTitleLabel()
        setupDescriptionLabel()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupTitleLabel() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setupDescriptionLabel() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        titleLabel.text = props.title
        titleLabel.render(title: props.title, color: .textMain, typography: .subtitleFour)
        descriptionLabel.render(title: props.description, color: .textSecondary, typography: .bodyTwo)
    }
}
