//
//  HomeRecipesListView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class HomeRecipesListView: UIView {

    struct Props: Equatable {
        let items: [RecipeCell.Props]
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, RecipeCell.Props>

    // MARK: - Properties

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = makeDataSource()
    // callbacks
    var onTapItem: (IndexPath) -> Void = { _ in }
    var onTapLike: (IndexPath) -> Void = { _ in }

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
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cell: RecipeCell.self)
        addSubview(collectionView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 264)
        ])
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: 180, height: 264)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        dataSource.apply(sections: [0], items: [props.items])
    }

    // MARK: - Private methods

    private func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: RecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onTapLike = { [weak self, unowned cell] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapLike(indexPath)
                    }
                }
                return cell
            }
        )
    }
}

// MARK: - UICollectionViewDelegate

extension HomeRecipesListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}
