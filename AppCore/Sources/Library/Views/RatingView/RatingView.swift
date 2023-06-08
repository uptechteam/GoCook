//
//  RatingView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public final class RatingView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        /// isActive tells whether at least one review is left.
        public let isActive: Bool
        public let ratingText: String
        public let description: String

        // MARK: - Lifecycle

        public init(isActive: Bool, ratingText: String, description: String) {
            self.isActive = isActive
            self.ratingText = ratingText
            self.description = description
        }
    }

    // MARK: - Properties

    private let starImageView = UIImageView()
    private let textLabel = UILabel()
    private let reviewsLabelLabel = UILabel()

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
        setupStarImageView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [starImageView, textLabel, reviewsLabelLabel, UIView()])
        stackView.alignment = .center
        stackView.spacing = 6
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupStarImageView() {
        starImageView.contentMode = .center
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Public methods

    public func render(props: Props) {
        starImageView.image = props.isActive ? .star20 : .starGray20
        textLabel.render(title: props.ratingText, color: .appBlack, typography: .other)
        textLabel.isHidden = !props.isActive
        textLabel.layoutIfNeeded()
        reviewsLabelLabel.render(title: props.description, color: .textSecondary, typography: .bodyTwo)
    }
}
