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

        // MARK: - Properties

        let id: String
        let recipeImageSource: ImageSource
        let isFavorite: Bool
        let name: String
        let ratingViewProps: RatingView.Props

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let favoriteButton = IconButton()
    private let nameLabel = UILabel()
    private let ratingView = RatingView()
    // callbacks
    var onTapFavorite: () -> Void = { }

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
        setupRecipeImageView()
        setupNameLabel()
        setupFavoriteButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, nameLabel, ratingView])
        stackView.axis = .vertical
        stackView.spacing = 8
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupRecipeImageView() {
        recipeImageView.backgroundColor = .gray100
        recipeImageView.clipsToBounds = true
        recipeImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupNameLabel() {
        nameLabel.numberOfLines = 2
    }

    private func setupFavoriteButton() {
        favoriteButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapFavorite() }), for: .touchUpInside)
        contentView.addSubview(favoriteButton, constraints: [
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource, placeholder: .mealPlaceholder)
        favoriteButton.set(image: props.isFavorite ? .circleWithFilledHeart : .circleWithEmptyHeart)
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}
