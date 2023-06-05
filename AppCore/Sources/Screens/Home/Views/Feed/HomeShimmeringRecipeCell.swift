//
//  HomeShimmeringRecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import Helpers
import Library
import UIKit

final class HomeShimmeringRecipeCell: UICollectionViewCell, ReusableCell {

    // MARK: - Properties

    private let squareShimmeringView = ShimmeringView()
    private let labelShimmeringView = ShimmeringView()
    private let ratingShimmeringView = ShimmeringView()
    private var identifier = UUID()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        toggle(isShimmering: true)
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        identifier = UUID()
        toggle(isShimmering: false)
    }

    // MARK: - Set up

    private func setup() {
        setupStackView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [squareShimmeringView, labelShimmeringView, ratingShimmeringView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            squareShimmeringView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            squareShimmeringView.heightAnchor.constraint(equalTo: squareShimmeringView.widthAnchor),
            labelShimmeringView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            labelShimmeringView.heightAnchor.constraint(equalToConstant: 48),
            ratingShimmeringView.widthAnchor.constraint(equalToConstant: 100)
        ])
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
