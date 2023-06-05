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

        // MARK: - Lifecycle

        public init(section: [Section], items: [[Item]]) {
            self.section = section
            self.items = items
        }
    }

    public typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>
    public typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>

    // MARK: - Properties

    public var diffableDataSource: DataSource?
    private var dataStore = [Int: Item]()
    private var isRendering = false
    private var pendingProps: Props?

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
        guard !isRendering else {
            // log.info("Rendering in progress, save props as pending")
            self.pendingProps = props
            return
        }

        // log.info("Rendering is started")
        isRendering = true
        updateDataStore(items: props.items)
        let itemsHashes = props.items.map { sectionItems in sectionItems.map(\.hashValue) }
        diffableDataSource?.applyWithReconfiguring(
            sections: props.section,
            items: itemsHashes,
            completion: { [weak self] in
                // log.info("Rendering is completed")
                self?.isRendering = false
                if let props = self?.pendingProps {
                    self?.pendingProps = nil
                    self?.render(props: props)
                }
            }
        )
    }

    public func getItem(for indexPath: IndexPath) -> Item? {
        guard let hashValue = diffableDataSource?.itemIdentifier(for: indexPath), let item = dataStore[hashValue] else {
            return nil
        }

        return item
    }

    // MARK: - Private methods

    private func updateDataStore(items: [[Item]]) {
        for item in items.flatMap({ $0 }) {
            dataStore[item.hashValue] = item
        }
    }
}
