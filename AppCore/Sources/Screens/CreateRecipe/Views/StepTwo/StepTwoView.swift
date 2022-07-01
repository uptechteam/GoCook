//
//  StepTwoView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Library
import UIKit

final class StepTwoView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let servingsViewProps: StepTwoServingsView.Props
        let ingredientsViewProps: StepTwoIngredientsView.Props
    }

    // MARK: - Properties

    let servingsView = StepTwoServingsView()
    let ingredientsView = StepTwoIngredientsView()
    private let spaceView = UIView()

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
        setupSpaceView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupSpaceView() {
        spaceView.setContentHuggingPriority(.required, for: .vertical)
        let constraint = spaceView.heightAnchor.constraint(equalToConstant: 0)
        constraint.priority = .init(249)
        NSLayoutConstraint.activate([
            constraint
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [servingsView, ingredientsView, spaceView])
        stackView.axis = .vertical
        stackView.setCustomSpacing(56, after: servingsView)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        servingsView.render(props: props.servingsViewProps)
        ingredientsView.render(props: props.ingredientsViewProps)
    }
}
