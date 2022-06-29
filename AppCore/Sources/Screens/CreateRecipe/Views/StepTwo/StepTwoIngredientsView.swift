//
//  StepTwoIngredientsView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Library
import UIKit

final class StepTwoIngredientsView: UIView {

    struct Props: Equatable {
        let items: [IngredientCell.Props]
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, IngredientCell.Props>
    typealias DataSource = UICollectionViewDiffableDataSource<Int, IngredientCell.Props>

    // MARK: - Properties

    private let titleLabel = UILabel()
    private lazy var dataSource = makeDataSource()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    private let addIngredientButton = Button(
        config: ButtonConfig(
            buttonSize: .medium,
            colorConfig: ColorConfig(main: .primaryMain, secondary: .secondaryMain),
            isBackgroundVisible: false
        )
    )
    // callbacks
    var onDidTapIngredientName: (IndexPath) -> Void = { _ in }
    var onDidTapIngredientAmount: (IndexPath) -> Void = { _ in }
    var onDidTapDeleteIngredient: (IndexPath) -> Void = { _ in }
    var onDidTapAddIngredient: () -> Void = { }

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
        setupTitleLabel()
        setupCollectionView()
        setupAddIngredientButton()
        setupStackView()
    }

    private func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.render(title: "Ingredients", color: .textMain, typography: .subtitle)
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 26
        flowLayout.itemSize = CGSize(width: bounds.width, height: 24)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.isScrollEnabled = false
        collectionView.register(cell: IngredientCell.self)
    }

    private func setupAddIngredientButton() {
        addIngredientButton.setTitle("Add ingredient")
        addIngredientButton.setImage(.addIcon)
        addIngredientButton.addAction(
            UIAction(handler: { [weak self] _ in self?.onDidTapAddIngredient() }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, collectionView, addIngredientButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(24, after: titleLabel)
        stackView.setCustomSpacing(34, after: collectionView)
        addSubview(stackView, withEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            collectionViewHeightConstraint
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        collectionViewHeightConstraint.constant = CGFloat((props.items.count) * 24 + (props.items.count - 1) * 26)
        dataSource.apply(sections: [0], items: [props.items], animatingDifferences: false)
    }
}

// MARK: - Data Source

extension StepTwoIngredientsView {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, props in
                let cell: IngredientCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.render(props: props)
                cell.onDidTapName = { [weak self] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onDidTapIngredientName(indexPath)
                    }
                }
                cell.onDidTapAmount = { [weak self] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onDidTapIngredientAmount(indexPath)
                    }
                }
                cell.onDidTapDelete = { [weak self] in
                    if let indexPath = self?.collectionView.indexPath(for: cell) {
                        self?.onDidTapDeleteIngredient(indexPath)
                    }
                }
                return cell
            }
        )
        return dataSource
    }
}
