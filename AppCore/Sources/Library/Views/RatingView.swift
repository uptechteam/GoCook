//
//  RatingView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public final class RatingView: UIView {

    public struct Props: Equatable {
        public let ratingText: String

        public init(ratingText: String) {
            self.ratingText = ratingText
        }
    }

    // MARK: - Properties

    private let starImageView = UIImageView()
    private let textLabel = UILabel()

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
        setupStarImageView()
        setupTextLabel()
        setupStackView()
    }

    private func setupStarImageView() {
        starImageView.image = .star
        starImageView.contentMode = .center
        NSLayoutConstraint.activate([
            starImageView.widthAnchor.constraint(equalToConstant: 20),
            starImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    private func setupTextLabel() {
        textLabel.render(typography: .other)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [starImageView, textLabel, UIView()])
        stackView.spacing = 6
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func render(props: Props) {
        textLabel.text = props.ratingText
    }
}
