//
//  UICollectionView+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

extension UICollectionView {

    // MARK: - Public methods

    public func register<C: UICollectionViewCell>(cell: C.Type) where C: ReusableCell {
        register(cell.self, forCellWithReuseIdentifier: C.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }

        return cell
    }

    public func registerHeader<C: UICollectionReusableView>(view: C.Type) {
        registerSupplementaryView(view: view, ofKind: UICollectionView.elementKindSectionHeader)
    }

    public func registerFooter<C: UICollectionReusableView>(view: C.Type) {
        registerSupplementaryView(view: view, ofKind: UICollectionView.elementKindSectionFooter)
    }

    public func dequeueReusableHeader<T: UICollectionReusableView>(
        for indexPath: IndexPath,
        viewType: T.Type = T.self
    ) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            for: indexPath,
            viewType: viewType
        )
    }

    public func dequeueReusableFooter<T: UICollectionReusableView>(
        for indexPath: IndexPath,
        viewType: T.Type = T.self
    ) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            for: indexPath,
            viewType: viewType
        )
    }

    // MARK: - Private methods

    private func registerSupplementaryView<C: UICollectionReusableView>(view: C.Type, ofKind kind: String) {
        register(
            view.self,
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: String(describing: view.self)
        )
    }

    private func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath,
        viewType: T.Type = T.self
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: viewType.self),
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a header with identifier \(String(describing: T.self)) matching type \(viewType.self).")
        }

        return view
    }
}
