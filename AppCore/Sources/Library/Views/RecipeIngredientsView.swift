//
//  RecipeIngredientsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public final class RecipeIngredientsView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let servingsDescription: String
        public let ingredientsProps: [RecipeIngredientView.Props]

        // MARK: - Lifecycle

        public init(servingsDescription: String, ingredientsProps: [RecipeIngredientView.Props]) {
            self.servingsDescription = servingsDescription
            self.ingredientsProps = ingredientsProps
        }
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
        setupTopStackView()
        setupIngredientsStackView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTitleLabel() {
        titleLabel.render(title: "Ingredients", color: .textMain, typography: .subtitle)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
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

    public func render(props: Props) {
        servingsLabel.render(title: props.servingsDescription, color: .textSecondary, typography: .body)
        renderIngredients(props: props.ingredientsProps)
    }

    // MARK: - Private methods

    private func renderIngredients(props: [RecipeIngredientView.Props]) {
        ingredientsStackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
        props.map(createIngredientView).forEach(ingredientsStackView.addArrangedSubview)
    }

    private func createIngredientView(props: RecipeIngredientView.Props) -> UIView {
        let ingredientView = RecipeIngredientView()
        ingredientView.render(props: props)
        return ingredientView
    }
}
