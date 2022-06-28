//
//  SearchTextField.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

public final class SearchTextField: UITextField {

    // MARK: - Properties

    private let loopImageView = UIImageView()

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
        setupLoopImageView()
    }

    private func setupContentView() {
        backgroundColor = .gray50
        layer.roundCornersContinuosly(radius: 8)
        leftView = UIView()
        leftViewMode = .always
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 41)
        ])
    }

    private func setupLoopImageView() {
        loopImageView.image = .search
        addSubview(loopImageView, constraints: [
            loopImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            loopImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: 0, y: 0, width: 41, height: bounds.height)
    }
}
