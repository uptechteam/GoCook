//
//  RecipeIngredientsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Library
import UIKit

final class RecipeIngredientsView: UIView {

    struct Props: Equatable {
        let servingsDescription: String
        let ingredientsProps: [RecipeIngredientView.Props]
    }

    // MARK: - Properties

    private let topStackView = UIStackView()
    private let titleLabel = UILabel()
    private let servingsLabel = UILabel()
    private let ingredientsStackView = UIStackView()

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
        setupTitleLabel()
        setupServingsLabel()
        setupTopStackView()
        setupIngredientsStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTitleLabel() {
        titleLabel.render(title: "Ingredients", color: .textMain, typography: .subtitle)
    }

    private func setupServingsLabel() {
        // TODO: Add new typography
        servingsLabel.font = FontFamily.RedHatDisplay.regular.font(size: 16)
        servingsLabel.textColor = .textSecondary
    }

    private func setupTopStackView() {
        [titleLabel, UIView(), servingsLabel].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
    }

    private func setupIngredientsStackView() {
        ingredientsStackView.axis = .vertical
        ingredientsStackView.spacing = 17
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, ingredientsStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 32, left: 24, bottom: 33, right: 24))
    }

    // MARK: - Public methods

    func render(props: Props) {
        servingsLabel.text = props.servingsDescription
        renderIngredients(props: props.ingredientsProps)
    }

    // MARK: - Private methods

    private func renderIngredients(props: [RecipeIngredientView.Props]) {
        ingredientsStackView.arrangedSubviews.forEach(ingredientsStackView.removeArrangedSubview)
        props.map(createIngredientView).forEach(ingredientsStackView.addArrangedSubview)
    }

    private func createIngredientView(props: RecipeIngredientView.Props) -> UIView {
        let ingredientView = RecipeIngredientView()
        ingredientView.render(props: props)
        return ingredientView
    }
}
