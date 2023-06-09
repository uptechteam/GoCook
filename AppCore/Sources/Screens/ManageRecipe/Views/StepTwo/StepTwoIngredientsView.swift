//
//  StepTwoIngredientsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Library
import UIKit

final class StepTwoIngredientsView: UIView {

    struct Props: Equatable {
        let ingredientViewsProps: [StepTwoIngredientView.Props]
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let ingredientsStackView = UIStackView()
    private let addIngredientButton = Button(
        config: ButtonConfig(buttonSize: .medium, colorConfig: .primary, isBackgroundVisible: false)
    )
    // callbacks
    var onTapIngredientName: (Int) -> Void = { _ in }
    var onTapIngredientAmount: (Int) -> Void = { _ in }
    var onTapDeleteIngredient: (Int) -> Void = { _ in }
    var onTapAddIngredient: () -> Void = { }

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
        setupStackView()
        setupTitleLabel()
        setupIngredientsStackView()
        setupAddIngredientButton()
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, ingredientsStackView, addIngredientButton.centeredHorizontally()]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(24, after: titleLabel)
        stackView.setCustomSpacing(34, after: ingredientsStackView)
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.render(title: .manageRecipeStepTwoIngredientsTitle, color: .textMain, typography: .subtitle)
    }

    private func setupIngredientsStackView() {
        ingredientsStackView.axis = .vertical
        ingredientsStackView.spacing = 26
    }

    private func setupAddIngredientButton() {
        addIngredientButton.addAction(
            UIAction(handler: { [unowned self] _ in onTapAddIngredient() }),
            for: .touchUpInside
        )
        addIngredientButton.setImage(.addIcon)
        addIngredientButton.setTitle(.manageRecipeStepTwoAddIngredient)
    }

    // MARK: - Public methods

    func render(props: Props) {
        renderIngredients(viewsProps: props.ingredientViewsProps)
    }

    // MARK: - Private methods

    private func renderIngredients(viewsProps: [StepTwoIngredientView.Props]) {
        let ingredientViews = ingredientsStackView.subviews.compactMap { $0 as? StepTwoIngredientView }
        if ingredientViews.count == viewsProps.count {
            zip(ingredientViews, viewsProps).forEach { view, props in view.render(props: props) }
        } else {
            ingredientsStackView.subviews.forEach { $0.removeFromSuperview() }
            viewsProps.enumerated()
                .map(makeIngredientView)
                .forEach(ingredientsStackView.addArrangedSubview)
        }
    }

    private func makeIngredientView(index: Int, props: StepTwoIngredientView.Props) -> UIView {
        let ingredientView = StepTwoIngredientView()
        ingredientView.render(props: props)
        ingredientView.onTapName = { [weak self] in
            self?.onTapIngredientName(index)
        }
        ingredientView.onTapAmount = { [weak self] in
            self?.onTapIngredientAmount(index)
        }
        ingredientView.onTapDelete = { [weak self] in
            self?.onTapDeleteIngredient(index)
        }
        return ingredientView
    }
}
