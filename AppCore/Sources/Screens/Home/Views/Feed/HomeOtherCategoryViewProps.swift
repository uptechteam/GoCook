//
//  HomeOtherCategoryViewProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.11.2022.
//

import Library
import UIKit

final class HomeOtherCategoryView: UIView {

    struct Props: Equatable {
        let headerProps: HomeRecipeCategoryHeaderView.Props
        let recipesListViewProps: HomeRecipesListView.Props
    }

    // MARK: - Properties

    let headerView = HomeRecipeCategoryHeaderView()
    let recipesListView = HomeRecipesListView()

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
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, recipesListView])
        stackView.axis = .vertical
        stackView.spacing = 24
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerProps)
        recipesListView.render(props: props.recipesListViewProps)
    }
}