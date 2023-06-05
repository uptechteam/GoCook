//
//  CollectionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import Helpers
import UIKit

public final class CollectionView<Section, Item>: UICollectionView where Section: Hashable, Item: Hashable {

    public struct Props: Equatable {

        // MARK: - Properties

        public let section: [Section]
        public let items: [[Item]]
        public let isRefreshing: Bool

        // MARK: - Lifecycle

        public init(section: [Section], items: [[Item]], isRefreshing: Bool = false) {
            self.section = section
            self.items = items
            self.isRefreshing = isRefreshing
        }
    }

    public typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>
    public typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>

    // MARK: - Properties

    private let collectionRefreshControl = UIRefreshControl()
    public var diffableDataSource: DataSource?
    private var dataStore = [Int: Item]()
    private var isRendering = false
    private var pendingProps: Props?
    // callbacks
    public var onScrollToRefresh: () -> Void = { }

    // MARK: - Lifecycle

    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
    }

    private func setupContentView() {
        backgroundColor = .clear
    }

    // MARK: - Public methods

    public func configureDataSource(
        cellProvider: @escaping (UICollectionView, IndexPath, Item) -> UICollectionViewCell
    ) {
        diffableDataSource = DataSource(
            collectionView: self,
            cellProvider: { [weak self] collectionView, indexPath, hashValue in
                guard let item = self?.dataStore[hashValue] else {
                    return nil
                }

                return cellProvider(collectionView, indexPath, item)
            }
        )
    }

    public func render(props: Props) {
        guard !isRendering, !collectionRefreshControl.isRefreshing else {
            self.pendingProps = props
            return
        }

        isRendering = true
        updateDataStore(items: props.items)
        let itemsHashes = props.items.map { sectionItems in sectionItems.map(\.hashValue) }
        diffableDataSource?.applyWithReconfiguring(
            sections: props.section,
            items: itemsHashes,
            completion: { [weak self] in
                self?.isRendering = false
                if let props = self?.pendingProps {
                    self?.pendingProps = nil
                    self?.render(props: props)
                }
            }
        )
        if collectionRefreshControl.isRefreshing {
            collectionRefreshControl.endRefreshing()
        }
    }

    public func refreshProps() {
        collectionRefreshControl.endRefreshing()
        guard let props = pendingProps else {
            return
        }

        render(props: props)
    }

    public func getItem(for indexPath: IndexPath) -> Item? {
        guard let hashValue = diffableDataSource?.itemIdentifier(for: indexPath), let item = dataStore[hashValue] else {
            return nil
        }

        return item
    }

    public func enableRefreshControl() {
        collectionRefreshControl.addAction(
            UIAction(handler: { [weak self] _ in
                print("Refresh control changed: \(self?.collectionRefreshControl.isRefreshing as Any)")
                self?.onScrollToRefresh()
            }),
            for: .valueChanged
        )
        refreshControl = collectionRefreshControl
    }

    // MARK: - Private methods

    private func updateDataStore(items: [[Item]]) {
        for item in items.flatMap({ $0 }) {
            dataStore[item.hashValue] = item
        }
    }
}
