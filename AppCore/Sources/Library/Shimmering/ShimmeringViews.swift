//
//  ShimmeringViews.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import UIKit

// MARK: - ShimmeringCollectionViewCell

open class ShimmeringCollectionViewCell: UICollectionViewCell, ReusableCell, Shimmering {

    // MARK: - Properties

    private var identifier = UUID()

    // MARK: - Lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        toggle(isShimmering: true)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        identifier = UUID()
        toggle(isShimmering: false)
    }

    // MARK: - Public methods

    public func render() {
        let generatedIdentifier = UUID()
        identifier = generatedIdentifier
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard generatedIdentifier == self?.identifier else {
                return
            }

            self?.toggle(isShimmering: true)
        }
    }
}

// MARK: - ShimmeringImageView

public final class ShimmeringImageView: UIImageView, Shimmering {

    // MARK: - Properties

    private var shimmeringSize: CGSize

    override public var intrinsicContentSize: CGSize {
        shimmeringSize
    }

    // MARK: - Lifecycle

    public init(shimmeringSize: CGSize) {
        self.shimmeringSize = shimmeringSize
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updateShimmering()
    }
}

// MARK: - ShimmeringLabel

public final class ShimmeringLabel: UILabel, Shimmering {
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateShimmering()
    }
}

// MARK: - ShimmeringView

public final class ShimmeringView: UIView, Shimmering {

}
