//
//  UICollectionViewDiffableDataSource+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers
import UIKit

extension UICollectionViewDiffableDataSource {
    public func applyWithReconfiguring(
        sections: [SectionIdentifierType],
        items: [[ItemIdentifierType]],
        animatingDifferences: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var existingSnapshot = snapshot()
        let sectionsToDelete = existingSnapshot.sectionIdentifiers.filter { !sections.contains($0) }
        existingSnapshot.deleteSections(sectionsToDelete)
        var lastSection: SectionIdentifierType?
        for (section, sectionItems) in zip(sections, items) {
            let uniqueSectionItems = getUniqueItems(from: sectionItems)
            if existingSnapshot.sectionIdentifiers.contains(section) {
                let existingItems = existingSnapshot.itemIdentifiers(inSection: section)
                if uniqueSectionItems == existingItems {
                    existingSnapshot.reconfigureItems(existingItems)
                } else {
                    let itemsToDelete = existingItems.filter { !sectionItems.contains($0) }
                    existingSnapshot.deleteItems(itemsToDelete)
                    var lastItem: ItemIdentifierType?
                    for item in sectionItems {
                        if existingItems.contains(item) {
                            existingSnapshot.reconfigureItems([item])
                        } else if let lastItem {
                            existingSnapshot.insertItems([item], afterItem: lastItem)
                        } else if let someExistingItem = existingSnapshot.itemIdentifiers.first {
                            existingSnapshot.insertItems([item], beforeItem: someExistingItem)
                        } else {
                            existingSnapshot.appendItems([item], toSection: section)
                        }

                        lastItem = item
                    }
                }
            } else if let previousSection = lastSection {
                existingSnapshot.insertSections([section], afterSection: previousSection)
                existingSnapshot.appendItems(uniqueSectionItems, toSection: section)
            } else if let existingSection = existingSnapshot.sectionIdentifiers.first {
                existingSnapshot.insertSections([section], beforeSection: existingSection)
                existingSnapshot.appendItems(uniqueSectionItems, toSection: section)
            } else {
                existingSnapshot.appendSections([section])
                existingSnapshot.appendItems(uniqueSectionItems, toSection: section)
            }

            lastSection = section
        }

        apply(existingSnapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    public func apply(
        sections: [SectionIdentifierType],
        items: [[ItemIdentifierType]],
        animatingDifferences: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>()
        var itemsBySection: [SectionIdentifierType: [ItemIdentifierType]] = [:]
        for (section, sectionItems) in zip(sections, items) {
            itemsBySection[section] = sectionItems
        }

        let uniqueSections = getUniqueItems(from: sections)
        snapshot.appendSections(uniqueSections)

        for section in uniqueSections {
            let uniqueItems = getUniqueItems(from: itemsBySection[section]!)
            snapshot.appendItems(uniqueItems, toSection: section)
        }

        apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
    }

    func getUniqueItems<T>(from items: [T]) -> [T] where T: Hashable {
        var uniqueItems = [T]()
        var usedItems = Set<T>()
        for item in items {
            if !usedItems.contains(item) {
                usedItems.insert(item)
                uniqueItems.append(item)
            } else {
                log.error("Data item with duplicated identifier found.", metadata: ["Item": .string("\(item)")])
            }
        }
        return uniqueItems
    }
}
