//
//  HomeTrendingCategoryView.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.11.2022.
//

import Library
import UIKit

final class HomeTrendingCategoryCell: UICollectionViewCell, ReusableCell {

    struct Props: Equatable {
        let headerProps: HomeRecipeCategoryHeaderView.Props
        let categoriesCollectionViewProps: CollectionView<Int, CategoryCell.Props>.Props
        let recipesCollectionViewProps: HomeRecipesCollectionView.Props
    }

    // MARK: - Properties

    let headerView = HomeRecipeCategoryHeaderView()
    let categoriesCollectionView = CollectionView<Int, CategoryCell.Props>()
    let recipesCollectionView = HomeRecipesCollectionView()
    // callbacks
    var onTapCategory: (IndexPath) -> Void = { _ in }

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
        setupCategoriesCollectionView()
        setupCategoriesLayout()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [headerView, categoriesCollectionView, recipesCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 24
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupCategoriesCollectionView() {
        categoriesCollectionView.backgroundColor = .clear
        categoriesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        categoriesCollectionView.showsHorizontalScrollIndicator = false
        categoriesCollectionView.delegate = self
        categoriesCollectionView.configureDataSource { collectionView, indexPath, props in
            let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.render(props: props)
            return cell
        }
        categoriesCollectionView.register(cell: CategoryCell.self)
        NSLayoutConstraint.activate([
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func setupCategoriesLayout() {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 8
        categoriesCollectionView.setCollectionViewLayout(flowlayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        headerView.render(props: props.headerProps)
        categoriesCollectionView.render(props: props.categoriesCollectionViewProps)
        recipesCollectionView.render(props: props.recipesCollectionViewProps)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeTrendingCategoryCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapCategory(indexPath)
    }
}

// MARK: - HomeTrendingCategoryView

extension HomeTrendingCategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let props = categoriesCollectionView.getItem(for: indexPath) else {
            return .zero
        }

        return CategoryCell.calculateSize(for: props)
    }
}
