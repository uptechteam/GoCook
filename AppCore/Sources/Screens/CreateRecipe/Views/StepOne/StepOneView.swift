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
        let recipeViewProps: StepOneRecipeView.Props
        let mealNameInputViewProps: InputView.Props
        let items: [CategoryCell.Props]
        let isCategoryErrorLabelVisible: Bool
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CategoryCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CategoryCell.Props>

    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let errorView = ErrorView()
    let recipeView = StepOneRecipeView()
    let mealNameInputView = InputView()
    private let categoryLabel = UILabel()
    private lazy var dataSource = makeDataSource()
    private let collectionView = CollectionView()
    private let categoryErrorLabel = UILabel()
    private var collectionViewHeightConstraint: NSLayoutConstraint!
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

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupCategoryLabel()
        setupLayout()
        setupCollectionView()
        setupCategoryErrorLabel()
        setupStackView()
        setupScrollView()
        setupErrorView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupCategoryLabel() {
        categoryLabel.render(title: "Category", color: .textMain, typography: .subtitle)
        categoryLabel.setContentHuggingPriority(.required, for: .vertical)
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.register(cell: CategoryCell.self)
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            collectionViewHeightConstraint
        ])
    }

    private func setupCategoryErrorLabel() {
        categoryErrorLabel.render(title: "Select meal category", color: .errorMain, typography: .bodyTwo)
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [recipeView, mealNameInputView, categoryLabel, collectionView, categoryErrorLabel]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(48, after: recipeView)
        stackView.setCustomSpacing(20, after: mealNameInputView)
        stackView.setCustomSpacing(24, after: categoryLabel)
        stackView.setCustomSpacing(8, after: collectionView)
        scrollView.addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -48)
        ])
    }

    private func setupScrollView() {
        addSubview(scrollView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
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
        recipeView.render(props: props.recipeViewProps)
        mealNameInputView.render(props: props.mealNameInputViewProps)
        collectionViewHeightConstraint.constant = CGFloat(props.items.count * 24 + (props.items.count - 1) * 20)
        dataSource.apply(sections: [0], items: [props.items])
        categoryErrorLabel.isHidden = !props.isCategoryErrorLabelVisible
    }

    func updateBottomInset(keyboardHeight: CGFloat) {
        scrollView.contentInset.bottom = keyboardHeight
    }
}

// MARK: - Data Source

extension StepOneView {
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

extension StepOneView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 24)
    }
}
