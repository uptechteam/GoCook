//
//  ShimmeringSmallRecipeCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import Helpers
import UIKit

public final class ShimmeringSmallRecipeCell: UICollectionViewCell, ReusableCell {

    // MARK: - Properties

    private let squareShimmeringView = ShimmeringView()
    private let detailsStackView = UIStackView()
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
        setupDetailsStackView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [squareShimmeringView, detailsStackView, UIView()])
        stackView.alignment = .center
        stackView.spacing = 8
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            squareShimmeringView.widthAnchor.constraint(equalTo: squareShimmeringView.heightAnchor),
            squareShimmeringView.heightAnchor.constraint(equalTo: stackView.heightAnchor)
        ])
    }

    private func setupDetailsStackView() {
        [labelShimmeringView, ratingShimmeringView].forEach(detailsStackView.addArrangedSubview)
        detailsStackView.axis = .vertical
        detailsStackView.spacing = 8
        NSLayoutConstraint.activate([
            detailsStackView.widthAnchor.constraint(equalToConstant: 100),
            labelShimmeringView.heightAnchor.constraint(equalToConstant: 24),
            ratingShimmeringView.heightAnchor.constraint(equalToConstant: 20)
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
