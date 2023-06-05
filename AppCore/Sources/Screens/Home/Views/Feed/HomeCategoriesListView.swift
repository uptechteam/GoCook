//
//  CategoriesCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.07.2022.
//

import Library
import UIKit

final class HomeCategoriesListView: UIView {

    struct Props: Equatable {
        let collectionViewProps: CollectionView<Int, CategoryCell.Props>.Props
    }

    // MARK: - Properties

    private let collectionView = CollectionView<Int, CategoryCell.Props>()
    // callbacks
    var onTapItem: (IndexPath) -> Void = { _ in }

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
        setupContentView()
        setupDataSource()
        setupCollectionView()
        setupLayout()
    }

    private func setupContentView() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cell: CategoryCell.self)
        addSubview(collectionView, withEdgeInsets: .zero)
    }

    private func setupDataSource() {
        collectionView.configureDataSource { collectionView, indexPath, props in
            let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.render(props: props)
            return cell
        }
    }

    private func setupLayout() {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 8
        collectionView.setCollectionViewLayout(flowlayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        collectionView.render(props: props.collectionViewProps)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeCategoriesListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeCategoriesListView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let props = self.collectionView.getItem(for: indexPath) else {
            return .zero
        }

        return CategoryCell.calculateSize(for: props)
    }
}
