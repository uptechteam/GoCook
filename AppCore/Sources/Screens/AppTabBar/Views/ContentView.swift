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

    // MARK: - Public methods

    func render(props: Props) {

    }
}
