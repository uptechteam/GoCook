//
//  AppTabBarView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers
import Library
import UIKit

final class AppTabBarView: UIView {

    struct Props: Equatable {
        let favoritesImageSource: ImageSource
        let homeImageSource: ImageSource
        let profileImageSource: ImageSource
    }

    // MARK: - Properties

    private let favoritesButton = IconButton()
    private let homeButton = IconButton()
    private let profileButton = IconButton()
    // callbacks
    var onTapItem: (Int) -> Void = { _ in }

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
        setupFavoritesButton()
        setupHomeButton()
        setupProfileButton()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
        layer.roundCornersContinuosly(radius: 28)
        layer.addShadow(opacitiy: 0.1, radius: 7, offset: CGSize(width: 0, height: 4))
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 240),
            heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupFavoritesButton() {
        favoritesButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapItem(0) }), for: .touchUpInside)
    }

    private func setupHomeButton() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapItem(1) }), for: .touchUpInside)
    }

    private func setupProfileButton() {
        profileButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapItem(2) }), for: .touchUpInside)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [favoritesButton, homeButton, profileButton])
        stackView.spacing = 44
        addSubview(stackView, constraints: [
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        favoritesButton.set(image: props.favoritesImageSource.image)
        homeButton.set(image: props.homeImageSource.image)
        profileButton.set(image: props.profileImageSource.image)
    }
}
