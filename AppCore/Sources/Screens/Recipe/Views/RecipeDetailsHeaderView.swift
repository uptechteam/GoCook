//
//  RecipeDetailsHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeDetailsHeaderView: UIView {

    struct Props: Equatable {
        let name: String
        let contentStateView: ContentStateView.Props
        let authorViewProps: RecipeAuthorView.Props
        let isBottomContentVisible: Bool
        let ratingViewProps: RatingView.Props
        let timeViewProps: RecipeTimeView.Props
    }

    // MARK: - Properties

    private let separatorView = UIView()
    private let nameLabel = UILabel()
    let contentStateView = ContentStateView()
    private let authorView = RecipeAuthorView()
    private let bottomStackView = UIStackView()
    private let ratingView = RatingView()
    private let timeView = RecipeTimeView()

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
        setupSeparatorView()
        setupNameLabel()
        setupBottomStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupSeparatorView() {
        separatorView.backgroundColor = .gray200
        separatorView.layer.roundCornersContinuosly(radius: 1.5)
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 36),
            separatorView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }

    private func setupNameLabel() {
        nameLabel.numberOfLines = 2
    }

    private func setupBottomStackView() {
        [ratingView, timeView, UIView()].forEach(bottomStackView.addArrangedSubview)
        bottomStackView.setCustomSpacing(16, after: ratingView)
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [separatorView, nameLabel, contentStateView, authorView, bottomStackView]
        )
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(14.5, after: separatorView)
        stackView.setCustomSpacing(20, after: nameLabel)
        stackView.setCustomSpacing(20, after: authorView)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 14.5, left: 24, bottom: 32, right: 24))
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            authorView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            bottomStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        nameLabel.render(title: props.name, color: .textMain, typography: .headerTwo)
        contentStateView.render(props: props.contentStateView)
        authorView.render(props: props.authorViewProps)
        bottomStackView.isHidden = !props.isBottomContentVisible
        ratingView.render(props: props.ratingViewProps)
        timeView.render(props: props.timeViewProps)
    }
}
