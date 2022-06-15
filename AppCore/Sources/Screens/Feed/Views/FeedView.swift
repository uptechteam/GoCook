//
//  FeedView.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Library
import UIKit

final class FeedView: UIView {

    struct Props: Equatable {
        let items: [RecipeCategoryCell.Props]
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RecipeCategoryCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, RecipeCategoryCell.Props>

    // MARK: - Properties

    private let topStackView = UIStackView()
    let inputTextField = InputTextField()
    let filtersButton = IconButton()
    private lazy var dataSource = makeDataSource()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    // callbacks
    var onDidTapFilters: () -> Void = { }
    var onDidTapViewAll: (IndexPath) -> Void = { _ in }
    var onDidTapLike: (IndexPath) -> Void = { _ in }

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
        setupTopStackView()
        setupInputTextField()
        setupFiltersButton()
        setupLayout()
        setupCollectionView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTopStackView() {
        [inputTextField, filtersButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
        topStackView.spacing = 16
    }

    private func setupInputTextField() {
        inputTextField.placeholder = "Search..."
    }

    private func setupFiltersButton() {
        filtersButton.set(image: .filters)
        filtersButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapFilters() }), for: .touchUpInside)
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 40
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.register(cell: RecipeCategoryCell.self)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, collectionView])
        stackView.axis = .vertical
        stackView.spacing = 24
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 16, left: 24, bottom: 41, right: 24),
            isSafeAreaRequired: true
        )
    }

    // MARK: - Public methods

    func render(props: Props) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(props.items, toSection: 0)
        dataSource.apply(snapshot)
    }
}

// MARK: - Data Source

private extension FeedView {
    func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: RecipeCategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onDidTapViewAll = { [weak self] in
                    self?.onDidTapViewAll(indexPath)
                }
                cell.onDidTapLike = { [weak self] likeIndexPath in
                    self?.onDidTapLike(IndexPath(row: likeIndexPath.row, section: indexPath.row))
                }
                return cell
            }
        )
    }
}
