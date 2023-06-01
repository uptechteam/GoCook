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
        let items: [SmallRecipeCell.Props]
        let infoViewProps: ContentStateView.Props
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>

    // MARK: - Properties

    let headerView = AuthorHeaderView()
    private let recipesTitleLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = makeDataSource()
    private lazy var dataStore = [String: SmallRecipeCell.Props]()
    private let refreshControl = UIRefreshControl()
    private let recipesStateView = ContentStateView()
    // callbacks
    var onScrollToRefresh: () -> Void = { }
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
        setupRefreshControl()
    }

    private func setupContentView() {
        backgroundColor = .white
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, recipesTitleLabel, collectionView, recipesStateView])
        stackView.axis = .vertical
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupRecipesTitleLabel() {
        
    }

    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 24
        collectionView.delegate = self
        collectionView.register(cell: SmallRecipeCell.self)
        collectionView.showsVerticalScrollIndicator = false
    }

    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: bounds.width - 2 * 24, height: 120)
        layout.minimumLineSpacing = 16
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    private func setupRefreshControl() {
        refreshControl.addAction(
            UIAction(handler: { [weak self] _ in
                self?.collectionView.isScrollEnabled = false
                self?.onScrollToRefresh()
            }),
            for: .valueChanged
        )
        collectionView.addSubview(refreshControl)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
    }

    // MARK: - Private methods

    private func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, id in
                guard let props = self?.dataStore[id] else {
                    return nil
                }

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
            }
        )
    }

    private func renderCollection(props: Props) {
        collectionView.isHidden = !props.isCollectionViewVisible
        collectionView.isScrollEnabled = true
        props.items.forEach { dataStore[$0.id] = $0 }
        dataSource.applyWithReconfiguring(
            sections: [0],
            items: [props.items.map(\.id)],
            animatingDifferences: true
        )
    }
}

// MARK: - UICollectionViewDelegate

extension AuthorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}
