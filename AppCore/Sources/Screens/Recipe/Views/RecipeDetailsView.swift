//
//  RecipeDetailsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeDetailsView: UIView {

    struct Props: Equatable {
        let headerViewProps: RecipeDetailsHeaderView.Props
        let ingredientsViewProps: RecipeIngredientsView.Props
        let instructionsViewProps: RecipeInstructionsView.Props
    }

    // MARK: - Properties

    private let headerView = RecipeDetailsHeaderView()
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
    }

    private func setupContentView() {
        backgroundColor = .gray100
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, ingredientsView, instructionsView, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerViewProps)
        ingredientsView.render(props: props.ingredientsViewProps)
        instructionsView.render(props: props.instructionsViewProps)
    }
}
