//
//  FavoritesView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class FavoritesView: UIView {

    struct Props: Equatable {

    }

    // MARK: - Properties

    private let textLabel = UILabel()

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
        setupTextLabel()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTextLabel() {
        textLabel.text = "Favorites"
        addSubview(textLabel, constraints: [
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {

    }
}
