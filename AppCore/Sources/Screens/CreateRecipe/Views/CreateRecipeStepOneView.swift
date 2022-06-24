//
//  CreateRecipeStepOneView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Library
import UIKit

final class CreateRecipeStepOneView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
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
        textLabel.text = "Step one"
        addSubview(textLabel, constraints: [
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
    }
}
