//
//  RecipeHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeHeaderView: UIView {

    struct Props: Equatable {
        let title: String
        let isFavorite: Bool
    }

    // MARK: - Properties

    private let backButton = IconButton()
    private let titleLabel = UILabel()
    private let favoriteButton = IconButton()
    private let separatorView = UIView()
    // callbacks
    var onDidTapBack: () -> Void = { }
    var onDidTapFavorite: () -> Void = { }

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
        setupBackButton()
        setupTitleLabel()
        setupFavoriteButton()
        setupStackView()
        setupSeparatorView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupBackButton() {
        backButton.set(image: .backButton)
        backButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapBack() }),
            for: .touchUpInside
        )
    }

    private func setupTitleLabel() {
        titleLabel.render(typography: .subtitleTwo)
    }

    private func setupFavoriteButton() {
        favoriteButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapFavorite() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [backButton, titleLabel, favoriteButton])
        stackView.spacing = 16
        addSubview(stackView, constraints: [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    private func setupSeparatorView() {
        separatorView.backgroundColor = .divider
        addSubview(separatorView, constraints: [
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
        favoriteButton.set(image: props.isFavorite ? .heartFilled : .heartEmpty)
    }
}
