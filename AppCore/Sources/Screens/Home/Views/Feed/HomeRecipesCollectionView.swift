//
//  HomeRecipesCollectionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class HomeRecipesCollectionView: UIView {

    struct Props: Equatable {
        let collectionViewProps: CollectionView<Int, RecipeCell.Props>.Props
    }

    // MARK: - Properties

    private let collectionView = CollectionView<Int, RecipeCell.Props>()
    // callbacks
    var onTapItem: (IndexPath) -> Void = { _ in }
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
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.configureDataSource { [weak self] collectionView, indexPath, props in
            let cell: RecipeCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.render(props: props)
            cell.onTapFavorite = { [weak self, unowned cell] in
                if let indexPath = self?.collectionView.indexPath(for: cell) {
                    self?.onTapFavorite(indexPath)
                }
            }
            return cell
        }
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
        collectionView.render(props: props.collectionViewProps)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeRecipesCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}
