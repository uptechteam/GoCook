//
//  HomeFeedView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.11.2022.
//

import Helpers
import Library
import UIKit

final class HomeFeedView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let collectionViewProps: CollectionView<Int, Item>.Props
    }

    enum Item: Hashable {

        case other(HomeOtherCategoryCell.Props, category: String)
        case trending(HomeTrendingCategoryCell.Props)

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            switch self {
            case .other(_, let category):
                hasher.combine(category)

            case .trending:
                hasher.combine("Trending")
            }
        }
    }

    // MARK: - Properties

    let collectionView = CollectionView<Int, Item>()
    // callbacks
    var onTapCategory: (IndexPath) -> Void = { _ in }
    var onTapViewAll: (IndexPath) -> Void = { _ in }
    var onTapRecipe: (IndexPath) -> Void = { _ in }
    var onTapFavorite: (IndexPath) -> Void = { _ in }

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
        setupCollectionView()
        setupLayout()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.register(cell: HomeTrendingCategoryCell.self)
        collectionView.register(cell: HomeOtherCategoryCell.self)
        configureDataSource()
        collectionView.enableRefreshControl()
        addSubview(collectionView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 40
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        collectionView.render(props: props.collectionViewProps)
    }

    // MARK: - Private methods

    private func configureDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, item in
            switch item {
            case .other(let props, _):
                let cell: HomeOtherCategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.headerView.onTapViewAll = { [weak self, unowned cell] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapViewAll(indexPath)
                    }
                }
                cell.recipesCollectionView.onTapItem = { [weak self] innerIndexPath in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapRecipe(IndexPath(item: innerIndexPath.item, section: indexPath.item))
                    }
                }
                cell.recipesCollectionView.onTapFavorite = { [weak self] innerIndexPath in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapFavorite(IndexPath(item: innerIndexPath.item, section: indexPath.item))
                    }
                }
                return cell

            case .trending(let props):
                let cell: HomeTrendingCategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onTapCategory = { [weak self] indexPath in
                    self?.onTapCategory(indexPath)
                }
                cell.headerView.onTapViewAll = { [weak self, unowned cell] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapViewAll(indexPath)
                    }
                }
                cell.recipesCollectionView.onTapItem = { [weak self] innerIndexPath in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapRecipe(IndexPath(item: innerIndexPath.item, section: indexPath.item))
                    }
                }
                cell.recipesCollectionView.onTapFavorite = { [weak self] innerIndexPath in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapFavorite(IndexPath(item: innerIndexPath.item, section: indexPath.item))
                    }
                }
                return cell
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension HomeFeedView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.refreshProps()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionView.refreshProps()
        }
    }
}

// MARK: - HomeTrendingCategoryView

extension HomeFeedView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = self.collectionView.getItem(for: indexPath) else {
            return .zero
        }

        switch item {
        case .other:
            return CGSize(width: collectionView.bounds.width, height: 324)

        case .trending:
            return CGSize(width: collectionView.bounds.width, height: 380)
        }
    }
}
