//
//  RecipeCategoryCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class RecipeCategoryCell: UICollectionViewCell, ReusableCell, ScrollableCell {

    struct Props: Hashable {

        // MARK: - Properties

        let title: String
        let items: [RecipeCell.Props]

        // MARK: - Public methods

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, RecipeCell.Props>

    // MARK: - Properties

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    // callbacks
    var onDidTapItem: (IndexPath) -> Void = { _ in }
    var onDidTapLike: (IndexPath) -> Void = { _ in }

    var id: Int {
        hash
    }

    var scrollableOffset: CGFloat {
        get {
            collectionView.contentOffset.x
        }
        set {
            collectionView.setContentOffset(CGPoint(x: newValue, y: 0), animated: false)
        }
    }

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
        setupLayout()
        setupCollectionView()
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: 180, height: 264)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cell: RecipeCell.self)
        contentView.addSubview(collectionView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 264)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        dataSource.apply(sections: [0], items: [props.items])
    }
}

// MARK: - Data Source

private extension RecipeCategoryCell {
    func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: RecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onDidTapLike = { [weak self] in
                    self?.onDidTapLike(indexPath)
                }
                return cell
            }
        )
    }
}

// MARK: - Delegate

extension RecipeCategoryCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDidTapItem(indexPath)
    }
}
