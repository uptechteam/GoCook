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
    var onDidChangeSearchQuery: (String) -> Void = { _ in }
    var onDidTapFilters: () -> Void = { }
    var onDidTapViewAll: (IndexPath) -> Void = { _ in }
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
        inputTextField.placeholder = .feedSearchPlaceholder
        inputTextField.delegate = self
    }

    private func setupFiltersButton() {
        filtersButton.set(image: .filters)
        filtersButton.addAction(UIAction(handler: { [weak self] _ in self?.onDidTapFilters() }), for: .touchUpInside)
        NSLayoutConstraint.activate([
            filtersButton.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 40
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.delegate = self
        collectionView.contentInset.bottom = 41
        collectionView.register(cell: RecipeCategoryCell.self)
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, collectionView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        addSubview(stackView, constraints: [
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            topStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -48),
            collectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
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
                cell.onDidTapItem = { [weak self] itemIndexPath in
                    self?.onDidTapItem(IndexPath(item: itemIndexPath.item, section: indexPath.item))
                }
                cell.onDidTapLike = { [weak self] likeIndexPath in
                    self?.onDidTapLike(IndexPath(item: likeIndexPath.item, section: indexPath.item))
                }
                return cell
            }
        )
    }
}

// MARK: - Delegate

extension FeedView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text ?? ""
        let newText = oldText.replacingCharacters(in: Range(range, in: oldText)!, with: string)
        guard newText.count <= 30 else {
            return false
        }

        onDidChangeSearchQuery(newText)
        return true
    }
}

extension FeedView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 324)
    }
}
