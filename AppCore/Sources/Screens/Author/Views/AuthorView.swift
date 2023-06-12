//
//  AuthorView.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Library
import UIKit

final class AuthorView: UIView {

    struct Props: Equatable {
        let headerViewProps: AuthorHeaderView.Props
        let isCollectionViewVisible: Bool
        let collectionViewProps: CollectionView<Int, Item>.Props
        let recipesStateViewProps: ContentStateView.Props
    }

    enum Item: Hashable {
        case recipe(SmallRecipeCell.Props)
        case shimmering(Int)
    }

    // MARK: - Properties

    let headerView = AuthorHeaderView()
    private let recipesTitleLabel = UILabel()
    let collectionView = CollectionView<Int, Item>()
    let recipesStateView = ContentStateView()
    // callbacks
    var onTapItem: (IndexPath) -> Void = { _ in }
    var onTapFavorite: (IndexPath) -> Void = { _ in }
    var onScrollToEnd: () -> Void = { }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        guard subviews.isEmpty else {
            return
        }

        setup()
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupStackView()
        setupRecipesTitleLabel()
        setupCollectionView()
        setupLayout()
    }

    private func setupContentView() {
        backgroundColor = .white
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                headerView,
                recipesTitleLabel.insetBy(top: 0, left: 24, bottom: 0, right: 24),
                collectionView,
                recipesStateView
            ]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(32, after: headerView)
        stackView.setCustomSpacing(32, after: headerView)
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupRecipesTitleLabel() {
        recipesTitleLabel.render(title: .authorRecipesTitle, color: .textMain, typography: .headerFour)
    }

    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.top = 24
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.enableRefreshControl()
        collectionView.register(cell: ShimmeringSmallRecipeCell.self)
        collectionView.register(cell: SmallRecipeCell.self)
        configureDataSource()
    }

    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bounds.width - 2 * 24, height: 120)
        layout.minimumLineSpacing = 16
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
        collectionView.isHidden = !props.isCollectionViewVisible
        collectionView.render(props: props.collectionViewProps)
        recipesStateView.render(props: props.recipesStateViewProps)
    }

    // MARK: - Private methods

    private func configureDataSource() {
        collectionView.configureDataSource { [weak self] collectionView, indexPath, item in
            switch item {
            case .recipe(let props):
                let cell: SmallRecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onTapFavorite = { [weak self, unowned cell] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapFavorite(indexPath)
                    }
                }
                if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
                    self?.onScrollToEnd()
                }

                return cell

            case .shimmering:
                let cell: ShimmeringSmallRecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render()
                return cell
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AuthorView: UICollectionViewDelegate {

    // MARK: - Collection view

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }

    // MARK: - Scroll view

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.refreshProps()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionView.refreshProps()
        }
    }
}
