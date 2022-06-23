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

    public override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.7 : 1
        }
    }

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
        setupImageView()
    }

    private func setupImageView() {
        imageView.contentMode = .center
        addSubview(imageView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    public func set(image: UIImage?) {
        imageView.image = image
    }
}
