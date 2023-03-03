//
//  SmallRecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Helpers
import Library
import UIKit

final class SmallRecipeCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {

        // MARK: - Properties

        let id: String
        let recipeImageSource: ImageSource
        let isLiked: Bool
        let name: String
        let ratingViewProps: RatingView.Props

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let likeButton = IconButton()
    private let nameStackView = UIStackView()
    private let nameLabel = UILabel()
    private let ratingView = RatingView()
    // callbacks
    var onTapLike: () -> Void = { }

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
        setupRecipeImageView()
        setupNameStackView()
        setupNameLabel()
        setupStackView()
        setupLikeButton()
    }

    private func setupRecipeImageView() {
        recipeImageView.backgroundColor = .gray100
        recipeImageView.clipsToBounds = true
        recipeImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupNameStackView() {
        [nameLabel, ratingView].forEach(nameStackView.addArrangedSubview)
        nameStackView.axis = .vertical
        nameStackView.alignment = .leading
        nameStackView.spacing = 8
    }

    private func setupNameLabel() {
        nameLabel.numberOfLines = 2
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, nameStackView])
        stackView.alignment = .center
        stackView.spacing = 16
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupLikeButton() {
        likeButton.set(image: .circleFavoriteEmpty)
        likeButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapLike() }), for: .touchUpInside)
        contentView.addSubview(likeButton, constraints: [
            likeButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 4),
            likeButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -4)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource, placeholder: .mealPlaceholder)
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}