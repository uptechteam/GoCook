//
//  CategoriesCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.07.2022.
//

import Library
import UIKit

final class CategoriesCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {
        let items: [CategoryCell.Props]

        func hash(into hasher: inout Hasher) {
            hasher.combine("Categories")
        }
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CategoryCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CategoryCell.Props>

    // MARK: - Properties

    private lazy var dataSource = makeDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    // callbacks
    var onDidTapItem: (IndexPath) -> Void = { _ in }

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
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 8
        collectionView.setCollectionViewLayout(flowlayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cell: CategoryCell.self)
        contentView.addSubview(collectionView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        dataSource.apply(sections: [0], items: [props.items])
    }
}

// MARK: - Data Source

private extension CategoriesCell {
    func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView) { collectionView, indexPath, props in
                let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                return cell
            }
    }
}

// MARK: - Delegate

extension CategoriesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let props = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }

        return CategoryCell.calculateSize(for: props)
    }
}
