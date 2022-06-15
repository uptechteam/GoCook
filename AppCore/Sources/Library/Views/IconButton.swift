//
//  IconButton.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

public final class IconButton: UIControl {

    // MARK: - Properties

    private let imageView = UIImageView()

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
        setupImageView()
    }

    private func setupContentView() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupImageView() {
        addSubview(imageView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func set(image: UIImage?) {
        imageView.image = image
    }
}
