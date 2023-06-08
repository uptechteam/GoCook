//
//  FavoriteRecipesView.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Library
import UIKit

final class FavoriteRecipesView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let collectionViewProps: CollectionView<Int, Item>.Props
    }

    enum Item: Hashable {
        case recipe(SmallRecipeCell.Props)
        case shimmering(Int)
    }

    // MARK: - Properties

    let collectionView = CollectionView<Int, Item>()
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
        setupCollectionView()
        setupLayout()
    }

    private func setupCollectionView() {
        collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.enableRefreshControl()
        collectionView.register(cell: ShimmeringSmallRecipeCell.self)
        collectionView.register(cell: SmallRecipeCell.self)
        configureDataSource()
        addSubview(collectionView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: bounds.width, height: 120)
        flowLayout.minimumLineSpacing = 24
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        collectionView.render(props: props.collectionViewProps)
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

extension FavoriteRecipesView: UICollectionViewDelegate {

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
