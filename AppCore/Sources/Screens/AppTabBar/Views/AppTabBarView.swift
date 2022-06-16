//
//  AppTabBarView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class AppTabBarView: UIView {

    struct Props: Equatable {
        let activeIndex: Int
    }

    // MARK: - Properties

    private let favoritesButton = IconButton()
    private let homeButton = IconButton()
    private let profileButton = IconButton()
    // callbacks
    var onDidTapItem: (Int) -> Void = { _ in }

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
        favoritesButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapItem(0) }), for: .touchUpInside)
    }

    private func setupHomeButton() {
        homeButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapItem(1) }), for: .touchUpInside)
    }

    private func setupProfileButton() {
        profileButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapItem(2) }), for: .touchUpInside)
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
        favoritesButton.set(image: props.activeIndex == 0 ? .favoritesTabBarIconSelected : .favoritesTabBarIconDeselected)
        homeButton.set(image: props.activeIndex == 1 ? .homeTabBarIconSelected : .homeTabBarIconDeselected)
        profileButton.set(image: props.activeIndex == 2 ? .profileTabBarIconSelected : .profileTabBarIconDeselected)
    }
}
