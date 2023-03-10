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
        let items: [ProfileRecipeCell.Props]
        let infoViewProps: ProfileInfoView.Props
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, String>

    // MARK: - Properties

    let headerView = ProfileHeaderView()
    let recipesHeaderView = ProfileRecipesHeaderView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = makeDataSource()
    private lazy var dataStore = [String: ProfileRecipeCell.Props]()
    private let refreshControl = UIRefreshControl()
    let infoView = ProfileInfoView()
    // callbacks
    var onScrollToRefresh: () -> Void = { }
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
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, recipesHeaderView, collectionView, infoView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(24, after: headerView)
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            recipesHeaderView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            infoView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -140)
        ])
    }

    private func setupCollectionView() {
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.contentInset.top = 24
        collectionView.delegate = self
        collectionView.register(cell: ProfileRecipeCell.self)
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
        recipesHeaderView.render(props: props.recipesHeaderViewProps)
        renderCollection(props: props)
        infoView.render(props: props.infoViewProps)
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }

    // MARK: - Private methods

    private func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, id in
                guard let props = self?.dataStore[id] else {
                    return nil
                }

                let cell: ProfileRecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onTapFavorite = {

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

extension ProfileView: UICollectionViewDelegate {

}
