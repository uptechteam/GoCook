//
//  ProfileRecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Helpers
import Library
import UIKit

final class ProfileRecipeCell: UICollectionViewCell, ReusableCell {

    struct Props: Equatable {
        let id: String
        let recipeImageSource: ImageSource
        let favoriteImageSource: ImageSource
        let name: String
        let ratingViewProps: RatingView.Props
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let favoriteButton = IconButton()
    private let nameStackView = UIStackView()
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
        setupFavoriteImageView()
        setupNameStackView()
        setupNameLabel()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, nameStackView])
        stackView.alignment = .center
        stackView.spacing = 16
        contentView.addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupRecipeImageView() {
        recipeImageView.clipsToBounds = true
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 120),
            recipeImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupFavoriteImageView() {
        favoriteButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapFavorite() }), for: .touchUpInside)
        recipeImageView.addSubview(favoriteButton, constraints: [
            favoriteButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 4),
            favoriteButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -4),
            favoriteButton.widthAnchor.constraint(equalToConstant: 36),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func setupNameStackView() {
        [nameLabel, ratingView].forEach(nameStackView.addArrangedSubview)
        nameStackView.axis = .vertical
        nameStackView.alignment = .leading
        nameStackView.spacing = 8
    }

    private func setupNameLabel() {
        nameLabel.numberOfLines = 0
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource)
        favoriteButton.set(image: props.favoriteImageSource.image)
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}
