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
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let backButton = IconButton()
    // callbacks
    var onDidTapBack: () -> Void = { }

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
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupRecipeImageView() {
        recipeImageView.contentMode = .scaleAspectFill
        addSubview(recipeImageView, constraints: [
            recipeImageView.topAnchor.constraint(equalTo: topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipeImageView.widthAnchor.constraint(equalTo: recipeImageView.heightAnchor)
        ])
    }

    private func setupBackButton() {
        backButton.backgroundColor = .appWhite
        backButton.layer.roundCornersContinuosly(radius: 22)
        backButton.set(image: .backButton)
        backButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapBack() }), for: .touchUpInside)
        recipeImageView.addSubview(backButton, constraints: [
            backButton.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 46),
            backButton.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor, constant: 12),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource)
    }
}
