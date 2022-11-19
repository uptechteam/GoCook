//
//  HomeFeedView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.11.2022.
//

import Library
import UIKit

final class HomeFeedView: UIView {

    struct Props: Equatable {
        let trendingCategoryViewProps: HomeTrendingCategoryView.Props
        let otherCategoriesViewsProps: [HomeOtherCategoryView.Props]
    }

    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    let trendingCategoryView = HomeTrendingCategoryView()
    // callbacks
    var onTapViewAll: (Int) -> Void = { _ in }
    var onTapRecipe: (IndexPath) -> Void = { _ in }
    var onTapLike: (IndexPath) -> Void = { _ in }

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
    }

    private func setupScrollView() {
        addSubview(scrollView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.addArrangedSubview(trendingCategoryView)
        scrollView.addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        trendingCategoryView.render(props: props.trendingCategoryViewProps)
        renderOtherCategories(viewsProps: props.otherCategoriesViewsProps)
    }

    // MARK: - Private methods

    private func renderOtherCategories(viewsProps: [HomeOtherCategoryView.Props]) {
        let otherCategoriesViews = stackView.subviews.compactMap { $0 as? HomeOtherCategoryView }
        if otherCategoriesViews.count != viewsProps.count {
            otherCategoriesViews.forEach { $0.removeFromSuperview() }
            viewsProps.enumerated()
                .map(createOtherCategoryView)
                .forEach(stackView.addArrangedSubview)
        } else {
            zip(otherCategoriesViews, viewsProps)
                .forEach { view, props in view.render(props: props) }
        }
    }

    private func createOtherCategoryView(index: Int, props: HomeOtherCategoryView.Props) -> UIView {
        let otherCategoryView = HomeOtherCategoryView()
        otherCategoryView.render(props: props)
        otherCategoryView.headerView.onTapViewAll = { [weak self] in
            self?.onTapViewAll(index)
        }
        otherCategoryView.recipesListView.onTapItem = { [weak self] indexPath in
            self?.onTapRecipe(IndexPath(item: indexPath.item, section: index))
        }
        otherCategoryView.recipesListView.onTapLike = { [weak self] indexPath in
            self?.onTapLike(IndexPath(item: indexPath.item, section: index))
        }
        return otherCategoryView
    }
}
