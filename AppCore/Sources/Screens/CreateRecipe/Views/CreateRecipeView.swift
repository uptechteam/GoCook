//
//  CreateRecipeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Library
import UIKit

final class CreateRecipeView: UIView {

    struct Props: Equatable {
        let stepsViewProps: CreateRecipeStepsView.Props
    }

    // MARK: - Properties

    let stepsView = CreateRecipeStepsView()

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
        setupStepsView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStepsView() {
        addSubview(stepsView, constraints: [
            stepsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -56),
            stepsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [UIView()])
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        stepsView.render(props: props.stepsViewProps)
    }
}
