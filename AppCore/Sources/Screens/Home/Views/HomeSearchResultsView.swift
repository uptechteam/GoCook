//
//  bottomAnchor.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Library
import UIKit

final class HomeSearchResultsView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let filterDescriptionViewProps: FiltersDescriptionView.Props
        let isCollectionViewVisible: Bool
        let collectionViewProps: CollectionView<Int, Item>.Props
        let contentStateViewProps: ContentStateView.Props
    }

    enum Item: Hashable {
        case recipe(SmallRecipeCell.Props)
        case shimmering(Int)
    }

    // MARK: - Properties

    private let filterDescriptionView = FiltersDescriptionView()
    private let collectionView = CollectionView<Int, Item>()
    let contentStateView = ContentStateView()
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
        setupStackView()
        setupCollectionView()
        setupLayout()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [filterDescriptionView, collectionView, contentStateView])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.register(cell: ShimmeringSmallRecipeCell.self)
        collectionView.register(cell: SmallRecipeCell.self)
        configureDataSource()
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.itemSize = CGSize(width: bounds.width, height: 120)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        filterDescriptionView.render(props: props.filterDescriptionViewProps)
        collectionView.isHidden = !props.isCollectionViewVisible
        collectionView.render(props: props.collectionViewProps)
        contentStateView.render(props: props.contentStateViewProps)
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

extension HomeSearchResultsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}
