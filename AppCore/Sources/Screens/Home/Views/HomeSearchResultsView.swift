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
        let filterDescriptionViewProps: HomeFiltersDescriptionView.Props
        let items: [SmallRecipeCell.Props]
        let isSpinnerVisible: Bool
        let isNoResultsLabelVisible: Bool
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SmallRecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SmallRecipeCell.Props>

    // MARK: - Properties

    private let filterDescriptionView = HomeFiltersDescriptionView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private lazy var dataSource = makeDataSource()
    private let spinnerView = SpinnerView(circleColor: .appBlack)
    private let noResultsLabel = UILabel()
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
        setupNoResultsLabel()
        setupSpinnerView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [filterDescriptionView, collectionView])
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

    private func setupSpinnerView() {
        addSubview(spinnerView, constraints: [
            spinnerView.topAnchor.constraint(equalTo: topAnchor, constant: 174),
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.widthAnchor.constraint(equalToConstant: 40),
            spinnerView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupNoResultsLabel() {
        noResultsLabel.render(title: "No results found", color: .textDisabled, typography: .body)
        addSubview(noResultsLabel, constraints: [
            noResultsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 174),
            noResultsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        filterDescriptionView.render(props: props.filterDescriptionViewProps)
        dataSource.apply(sections: [0], items: [props.items])
        spinnerView.toggle(isAnimating: props.isSpinnerVisible)
        noResultsLabel.isHidden = !props.isNoResultsLabelVisible
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
