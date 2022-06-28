//
//  CreateRecipeStepOneView.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.06.2022.
//

import Library
import UIKit

final class CreateRecipeStepOneView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let recipeImageViewProps: RecipeImageView.Props
        let mealNameInputViewProps: InputView.Props
        let items: [CategoryCell.Props]
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CategoryCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CategoryCell.Props>

    // MARK: - Properties

    let recipeImageView = RecipeImageView()
    let mealNameInputView = InputView()
    private let categoryLabel = UILabel()
    private lazy var dataSource = makeDataSource()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    // callbacks
    var onDidTapCategory: (IndexPath) -> Void = { _ in }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupCategoryLabel()
        setupLayout()
        setupCollectionView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupCategoryLabel() {
        categoryLabel.render(title: "Category", color: .textMain, typography: .subtitle)
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.itemSize = CGSize(width: bounds.width - 48, height: 24)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.register(cell: CategoryCell.self)
    }

    var collectionViewHeightConstraint: NSLayoutConstraint!

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, mealNameInputView, categoryLabel, collectionView])
        stackView.axis = .vertical
        stackView.setCustomSpacing(48, after: recipeImageView)
        stackView.setCustomSpacing(20, after: mealNameInputView)
        stackView.setCustomSpacing(24, after: categoryLabel)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            collectionViewHeightConstraint
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        recipeImageView.render(props: props.recipeImageViewProps)

        mealNameInputView.render(props: props.mealNameInputViewProps)
        collectionViewHeightConstraint.constant = CGFloat(props.items.count * 24 + (props.items.count - 1) * 20)
        dataSource.apply(sections: [0], items: [props.items])
    }
}

// MARK: - Data Source

extension CreateRecipeStepOneView {
    func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: CategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onDidTapCheckmark = { [weak self] in
                    self?.onDidTapCategory(indexPath)
                }
                return cell
            }
        )
    }
}
