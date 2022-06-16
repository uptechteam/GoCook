//
//  RecipeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import Helpers
import UIKit

final class RecipeView: UIView {

    struct Props: Equatable {
        let recipeImageSource: ImageSource
        let isLiked: Bool
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let backButton = IconButton()
    private let likeButton = IconButton()
    // callbacks
    var onDidTapBack: () -> Void = { }
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
        setupContentView()
        setupRecipeImageView()
        setupBackButton()
        setupLikeButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupRecipeImageView() {
        recipeImageView.clipsToBounds = true
        recipeImageView.contentMode = .scaleAspectFill
        addSubview(recipeImageView, constraints: [
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupBackButton() {
        backButton.set(image: .circleBackButton)
        backButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapBack() }), for: .touchUpInside)
        addSubview(backButton, constraints: [
            backButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 46),
            backButton.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 12)
        ])
    }

    private func setupLikeButton() {
        likeButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapLike() }), for: .touchUpInside)
        addSubview(likeButton, constraints: [
            likeButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 46),
            likeButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -12)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource)
        likeButton.set(image: props.isLiked ? .likeEnabled : .likeDisabled)
    }
}
