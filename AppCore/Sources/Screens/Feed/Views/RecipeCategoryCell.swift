//
//  RecipeCategoryCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class RecipeCategoryCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {
        let title: String
        let items: [RecipeCell.Props]

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, RecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, RecipeCell.Props>

    // MARK: - Properties

    private let topStackView = UIStackView()
    private let titleLabel = UILabel()
    private let viewAllButton = UIButton()
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    // callbacks
    var onDidTapViewAll: () -> Void = { }
    var onDidTapItem: (IndexPath) -> Void = { _ in }
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
        setupTopStackView()
        setupTitleLabel()
        setupViewAllButton()
        setupLayout()
        setupCollectionView()
        setupStackView()
    }

    private func setupTopStackView() {
        [titleLabel, UIView(), viewAllButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
    }

    private func setupTitleLabel() {
        titleLabel.render(typography: .headerTwo)
    }

    private func setupViewAllButton() {
        viewAllButton.setTitle(.feedCategoryViewAll, for: .normal)
        viewAllButton.setTitleColor(.primaryMain, for: .normal)
        viewAllButton.setTitleColor(.primaryPressed, for: .highlighted)
        viewAllButton.titleLabel?.render(typography: .buttonLarge)
        viewAllButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapViewAll() }), for: .touchUpInside)
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: 180, height: 264)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(cell: RecipeCell.self)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, collectionView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        contentView.addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            topStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 264)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.text = props.title
        render(items: props.items)
    }

    // MARK: - Private methods

    private func render(items: [RecipeCell.Props]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        dataSource.apply(snapshot)
    }
}

// MARK: - Data Source

private extension RecipeCategoryCell {
    func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: RecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onDidTapLike = { [weak self] in
                    self?.onDidTapLike(indexPath)
                }
                return cell
            }
        )
    }
}

// MARK: - Delegate

extension RecipeCategoryCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDidTapItem(indexPath)
    }
}
