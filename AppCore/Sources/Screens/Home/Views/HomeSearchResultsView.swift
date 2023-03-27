//
//  bottomAnchor.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Library
import UIKit

final class HomeSearchResultsView: UIView {

    struct Props: Equatable {
        let isVisible: Bool
        let filterDescriptionViewProps: FiltersDescriptionView.Props
        let isCollectionViewVisible: Bool
        let items: [SmallRecipeCell.Props]
        let contentStateViewProps: ContentStateView.Props
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SmallRecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SmallRecipeCell.Props>

    // MARK: - Properties

    private let filterDescriptionView = FiltersDescriptionView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = makeDataSource()
    let contentStateView = ContentStateView()
    // callbacks
    var onTapItem: (IndexPath) -> Void = { _ in }
    var onTapFavorite: (IndexPath) -> Void = { _ in }
    var onScrollToEnd: () -> Void = { }

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
        setupStackView()
        setupCollectionView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [filterDescriptionView, collectionView, contentStateView])
        stackView.axis = .vertical
        stackView.spacing = 16
        addSubview(stackView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.register(cell: SmallRecipeCell.self)
    }

    private func setupLayout() {
        guard !(collectionView.collectionViewLayout is UICollectionViewFlowLayout) else {
            return
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.itemSize = CGSize(width: bounds.width, height: 120)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        filterDescriptionView.render(props: props.filterDescriptionViewProps)
        collectionView.isHidden = !props.isCollectionViewVisible
        dataSource.apply(sections: [0], items: [props.items])
        contentStateView.render(props: props.contentStateViewProps)
    }

    // MARK: - Private methods

    private func makeDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, props in
                let cell: SmallRecipeCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onTapFavorite = { [weak self, unowned cell] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onTapFavorite(indexPath)
                    }
                }
                if indexPath.item == collectionView.numberOfItems(inSection: 0) - 1 {
                    self?.onScrollToEnd()
                }

                return cell
            }
        )
    }
}

// MARK: - UICollectionViewDelegate

extension HomeSearchResultsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onTapItem(indexPath)
    }
}
