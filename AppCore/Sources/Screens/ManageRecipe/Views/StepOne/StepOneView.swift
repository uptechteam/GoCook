//
//  StepOneView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Helpers
import Library
import UIKit

final class StepOneView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let errorViewProps: ErrorView.Props
        let recipeViewProps: ManageRecipeImageView.Props
        let mealNameInputViewProps: UserInputView.Props
        let categoryViewsProps: [StepOneCategoryView.Props]
        let isCategoryErrorLabelVisible: Bool
    }

    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let errorView = ErrorView()
    let recipeImageView = ManageRecipeImageView()
    let mealNameInputView = UserInputView()
    private let categoryLabel = UILabel()
    private let categoriesStackView = UIStackView()
    private let categoryErrorLabel = UILabel()
    // callbacks
    var onTapCategory: (Int) -> Void = { _ in }

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
        setupScrollView()
        setupStackView()
        setupContentView()
        setupMealNameInputView()
        setupCategoryLabel()
        setupCategoriesStackView()
        setupCategoryErrorLabel()
        setupErrorView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupScrollView() {
        addSubview(scrollView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [
                recipeImageView,
                mealNameInputView,
                categoryLabel,
                categoriesStackView,
                categoryErrorLabel
            ]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(48, after: recipeImageView)
        stackView.setCustomSpacing(20, after: mealNameInputView)
        stackView.setCustomSpacing(24, after: categoryLabel)
        stackView.setCustomSpacing(8, after: categoriesStackView)
        scrollView.addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupMealNameInputView() {
        mealNameInputView.configure(title: .manageRecipeStepOneMealTitle)
    }

    private func setupCategoryLabel() {
        categoryLabel.render(title: .manageRecipeStepOneCategoryTitle, color: .textMain, typography: .subtitle)
        categoryLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupCategoriesStackView() {
        categoriesStackView.axis = .vertical
        categoriesStackView.spacing = 20
    }

    private func setupCategoryErrorLabel() {
        categoryErrorLabel.render(
            title: .manageRecipeStepOneCategoryValidation,
            color: .errorMain,
            typography: .bodyTwo
        )
    }

    private func setupErrorView() {
        addSubview(errorView, constraints: [
            errorView.topAnchor.constraint(equalTo: topAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        errorView.render(props: props.errorViewProps)
        recipeImageView.render(props: props.recipeViewProps)
        mealNameInputView.render(props: props.mealNameInputViewProps)
        renderCategories(viewsProps: props.categoryViewsProps)
        categoryErrorLabel.isHidden = !props.isCategoryErrorLabelVisible
    }

    func updateBottomInset(keyboardHeight: CGFloat) {
        scrollView.contentInset.bottom = keyboardHeight
    }

    // MARK: - Private methods

    private func renderCategories(viewsProps: [StepOneCategoryView.Props]) {
        let categoryViews = categoriesStackView.subviews.compactMap { $0 as? StepOneCategoryView }
        if categoryViews.count == viewsProps.count {
            zip(categoryViews, viewsProps).forEach { view, props in view.render(props: props) }
        } else {
            categoriesStackView.subviews.forEach { $0.removeFromSuperview() }
            viewsProps.enumerated()
                .map(createCategoryView)
                .forEach(categoriesStackView.addArrangedSubview)
        }
    }

    private func createCategoryView(index: Int, props: StepOneCategoryView.Props) -> StepOneCategoryView {
        let categoryView = StepOneCategoryView()
        categoryView.render(props: props)
        categoryView.onTapCheckmark = { [weak self] in
            self?.onTapCategory(index)
        }
        return categoryView
    }
}
