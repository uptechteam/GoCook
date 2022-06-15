//
//  RecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class RecipeCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {
        let id: String
        let recipeImage: UIImage?
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
        setupLikeButton()
        setupNameLabel()
        setupStackView()
    }

    private func setupRecipeImageView() {
        recipeImageView.backgroundColor = .gray100
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupLikeButton() {
        likeButton.set(image: .likeDisabled)
        likeButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapLike() }), for: .touchUpInside)
        recipeImageView.addSubview(likeButton, constraints: [
            likeButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -8)
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

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.image = props.recipeImage
        nameLabel.render(title: props.name, color: .appBlack, typography: .subtitleTwo)
        ratingView.render(props: props.ratingViewProps)
    }
}
