//
//  RecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers
import Library
import UIKit

final class RecipeCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {
        let id: String
        let recipeImageSource: ImageSource
        let isLiked: Bool
        let name: String
        let ratingViewProps: RatingView.Props

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let likeButton = IconButton()
    private let nameLabel = UILabel()
    private let ratingView = RatingView()
    // callbacks
    var onDidTapLike: () -> Void = { }

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
        setupNameLabel()
        setupStackView()
        setupLikeButton()
    }

    private func setupRecipeImageView() {
        recipeImageView.clipsToBounds = true
        recipeImageView.backgroundColor = .gray100
        recipeImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupNameLabel() {
        nameLabel.render(typography: .subtitleTwo)
        nameLabel.numberOfLines = 2
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, nameLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 8
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupLikeButton() {
        likeButton.set(image: .circleFavoriteEmpty)
        likeButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapLike() }), for: .touchUpInside)
        contentView.addSubview(likeButton, constraints: [
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource, placeholder: .mealPlaceholder)
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}
