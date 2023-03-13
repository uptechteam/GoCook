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
        let items: [SmallRecipeCell.Props]
        let isSpinnerVisible: Bool
        let isNoResultsLabelVisible: Bool
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SmallRecipeCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, SmallRecipeCell.Props>

    // MARK: - Properties

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
        setupCollectionView()
        setupNoResultsLabel()
        setupSpinnerView()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = .zero
        collectionView.delegate = self
        collectionView.register(cell: SmallRecipeCell.self)
        addSubview(collectionView, withEdgeInsets: .zero)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    private func setupLayout() {
        guard !(collectionView.collectionViewLayout is UICollectionViewFlowLayout) else {
            return
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 24
        flowLayout.itemSize = CGSize(width: bounds.width, height: 120)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
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
