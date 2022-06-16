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
        let recipeDetailsViewProps: RecipeDetailsView.Props
    }

    // MARK: - Properties

    private let recipeImageView = UIImageView()
    private let backButton = IconButton()
    private let likeButton = IconButton()
    private let detailsView = RecipeDetailsView()
    private var isFirstLayoutFinished = false
    private var scrollViewTopConstraint: NSLayoutConstraint!
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

    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstLayoutFinished {
            isFirstLayoutFinished = true
            scrollViewTopConstraint.constant = bounds.width
        }
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupRecipeImageView()
        setupBackButton()
        setupLikeButton()
        setupDetailsView()
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

    private func setupDetailsView() {
        let scrollView = UIScrollView()
        scrollView.addSubview(detailsView, withEdgeInsets: .zero)
        scrollView.delegate = self
        scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        addSubview(scrollView, constraints: [
            scrollViewTopConstraint,
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            detailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        recipeImageView.set(props.recipeImageSource)
        likeButton.set(image: props.isLiked ? .likeEnabled : .likeDisabled)
        detailsView.render(props: props.recipeDetailsViewProps)
    }
}

extension RecipeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let adjustedConstraint = max(0, min(bounds.width, scrollViewTopConstraint.constant - offset))
        let delta = adjustedConstraint - scrollViewTopConstraint.constant
        scrollViewTopConstraint.constant = adjustedConstraint
        if delta != 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: offset + delta)
        }
    }
}
