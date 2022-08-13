//
//  HomeView.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Library
import UIKit

final class HomeView: UIView {

    struct Props: Equatable {
        let sections: [Section]
    }

    enum Section: Hashable {
        case category(RecipeCategoryHeaderView.Props, items: [Item])

        var items: [Item] {
            switch self {
            case .category(_, let items):
                return items
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case .category(let props, _):
                hasher.combine(props.title)
            }
        }
    }

    enum Item: Hashable {
        case categories(CategoriesCell.Props)
        case recipes(RecipeCategoryCell.Props)
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    // MARK: - Properties

    private let topStackView = UIStackView()
    let searchTextField = SearchTextField()
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
        setupSearchTextField()
        setupFiltersButton()
        setupLayout()
        setupCollectionView()
        setupStackView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupTopStackView() {
        [searchTextField, filtersButton].forEach(topStackView.addArrangedSubview)
        topStackView.alignment = .center
        topStackView.spacing = 16
    }

    private func setupSearchTextField() {
        searchTextField.placeholder = .homeSearchPlaceholder
        searchTextField.delegate = self
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
        flowLayout.minimumLineSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 24, left: 0, bottom: 40, right: 0)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = nil
        collectionView.delegate = self
        collectionView.registerHeader(view: RecipeCategoryHeaderView.self)
        collectionView.register(cell: CategoriesCell.self)
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
        dataSource.apply(sections: props.sections, items: props.sections.map(\.items))
    }
}

// MARK: - Data Source

private extension HomeView {
    func makeDataSource() -> DataSource {
        let dataSource =  DataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                switch item {
                case .categories(let props):
                    let cell: CategoriesCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.render(props: props)
                    return cell

                case .recipes(let props):
                    let cell: RecipeCategoryCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.render(props: props)
                    cell.onDidTapItem = { [weak self] itemIndexPath in
                        self?.onDidTapItem(IndexPath(item: itemIndexPath.item, section: indexPath.item))
                    }
                    cell.onDidTapLike = { [weak self] likeIndexPath in
                        self?.onDidTapLike(IndexPath(item: likeIndexPath.item, section: indexPath.item))
                    }
                    return cell
                }
            }
        )
        dataSource.supplementaryViewProvider = { [weak dataSource] collectionView, _, indexPath in
            guard let section = dataSource?.sectionIdentifier(for: indexPath.section) else {
                return nil
            }

            switch section {
            case .category(let props, _):
                let headerView: RecipeCategoryHeaderView = collectionView.dequeueReusableHeader(for: indexPath)
                headerView.render(props: props)
                return headerView
            }
        }
        return dataSource
    }
}

// MARK: - Delegate

extension HomeView: UITextFieldDelegate {
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

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return .zero
        }

        switch item {
        case .categories:
            return CGSize(width: collectionView.bounds.width, height: 32)

        case .recipes:
            return CGSize(width: collectionView.bounds.width, height: 264)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.bounds.width, height: 36)
    }
}
