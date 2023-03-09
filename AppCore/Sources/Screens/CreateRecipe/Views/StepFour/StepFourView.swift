//
//  StepFourView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Library
import UIKit

final class StepFourView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let headerViewProps: StepFourHeaderView.Props
        let ingredientsViewProps: RecipeIngredientsView.Props
        let instructionsViewProps: RecipeInstructionsView.Props
    }

    // MARK: - Properties

    private let scrollView = UIScrollView()
    let headerView = StepFourHeaderView()
    private let ingredientsView = RecipeIngredientsView()
    private let instructionsView = RecipeInstructionsView()

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
        setupStackView()
        setupScrollView()
    }

    private func setupContentView() {
        backgroundColor = .gray100
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, ingredientsView, instructionsView])
        stackView.axis = .vertical
        stackView.spacing = 8
        scrollView.addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupScrollView() {
        addSubview(scrollView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        headerView.render(props: props.headerViewProps)
        ingredientsView.render(props: props.ingredientsViewProps)
        instructionsView.render(props: props.instructionsViewProps)
    }
}
