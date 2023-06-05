//
//  CollectionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import UIKit

public final class CollectionViewChangeable: UICollectionView {

    // MARK: - Properties

    private var oldBounds: CGRect = .zero

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero, collectionViewLayout: .init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds != oldBounds {
            oldBounds = bounds
            collectionViewLayout.invalidateLayout()
        }
    }
}
