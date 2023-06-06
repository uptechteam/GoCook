//
//  ProfileView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class ProfileView: UIView {

    struct Props: Equatable {
        let headerViewProps: ProfileHeaderView.Props
        let recipesHeaderViewProps: ProfileRecipesHeaderView.Props
        let isCollectionViewVisible: Bool
        let collectionViewProps: CollectionView<Int, Item>.Props
        let profileStateView: ContentStateView.Props
    }

    enum Item: Hashable {
        case recipe(SmallRecipeCell.Props)
        case shimmering(Int)
    }

    // MARK: - Properties

    let headerView = ProfileHeaderView()
    let recipesHeaderView = ProfileRecipesHeaderView()
    let collectionView = CollectionView<Int, Item>()
    let profileStateView = ContentStateView()
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
        setupCollectionView()
        setupLayout()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, recipesHeaderView, collectionView, profileStateView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(24, after: headerView)
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            recipesHeaderView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            profileStateView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -140)
        ])
    }

    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.top = 24
        collectionView.delegate = self
        collectionView.enableRefreshControl()
        collectionView.register(cell: SmallRecipeCell.self)
        collectionView.register(cell: ShimmeringSmallRecipeCell.self)
        configureDataSource()
        collectionView.showsVerticalScrollIndicator = false
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
        recipesHeaderView.render(props: props.recipesHeaderViewProps)
        collectionView.isHidden = !props.isCollectionViewVisible
        collectionView.render(props: props.collectionViewProps)
        profileStateView.render(props: props.profileStateView)
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

extension ProfileView: UICollectionViewDelegate {

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
