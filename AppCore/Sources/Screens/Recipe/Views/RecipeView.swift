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
        let headerViewProps: RecipeHeaderView.Props
        let recipeImageSource: ImageSource
        let isLiked: Bool
        let recipeDetailsViewProps: RecipeDetailsView.Props
    }

    // MARK: - Properties

    let headerView = RecipeHeaderView()
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
        setupHeaderView()
    }

    private func setupContentView() {
        backgroundColor = .gray100
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
        scrollView.clipsToBounds = false
        scrollView.addSubview(detailsView, withEdgeInsets: .zero)
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
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

    private func setupHeaderView() {
        headerView.isHidden = true
        addSubview(headerView, constraints: [
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 56)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
        recipeImageView.set(props.recipeImageSource)
        likeButton.set(image: props.isLiked ? .circleFavoriteFilled : .circleFavoriteEmpty)
        detailsView.render(props: props.recipeDetailsViewProps)
    }

    // MARK: - Private methods

    private func renderHeaderVisibility() {
        headerView.isHidden = scrollViewTopConstraint.constant > 0
    }
}

extension RecipeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let minimumConstant = max(0, min(bounds.width, bounds.height - scrollView.contentSize.height + 1))
        let adjustedConstant = max(minimumConstant, min(bounds.width, scrollViewTopConstraint.constant - offset))
        let delta = adjustedConstant - scrollViewTopConstraint.constant
        scrollViewTopConstraint.constant = adjustedConstant
        if delta != 0 {
            scrollView.contentOffset = CGPoint(x: 0, y: offset + delta)
        }
        renderHeaderVisibility()
    }
}
