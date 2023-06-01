//
//  SmallRecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Helpers
import UIKit

public final class SmallRecipeCell: UICollectionViewCell, ReusableCell {

    public struct Props: Hashable {

        // MARK: - Properties

        public let id: String
        let recipeImageSource: ImageSource
        let isFavorite: Bool
        let name: String
        let ratingViewProps: RatingView.Props

        // MARK: - Lifecycle

        public init(
            id: String,
            recipeImageSource: ImageSource,
            isFavorite: Bool,
            name: String,
            ratingViewProps: RatingView.Props
        ) {
            self.id = id
            self.recipeImageSource = recipeImageSource
            self.isFavorite = isFavorite
            self.name = name
            self.ratingViewProps = ratingViewProps
        }

        // MARK: - Public methods

        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let favoriteButton = IconButton()
    private let nameStackView = UIStackView()
    private let nameLabel = UILabel()
    private let ratingView = RatingView()
    // callbacks
    public var onTapFavorite: () -> Void = { }

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
        setupFavoriteButton()
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

    private func setupFavoriteButton() {
        favoriteButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapFavorite() }), for: .touchUpInside)
        contentView.addSubview(favoriteButton, constraints: [
            favoriteButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 4),
            favoriteButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -4)
        ])
    }

    // MARK: - Public methods

    public func render(props: Props) {
        recipeImageView.set(props.recipeImageSource, placeholder: .mealPlaceholder)
        favoriteButton.set(image: props.isFavorite ? .circleWithFilledHeart : .circleWithEmptyHeart)
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}
