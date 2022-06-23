//
//  PersistenceModel.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import CoreData
import Foundation

/// `PersistanceModel` is a domain model that can be stored in Core Data
public protocol PersistenceModel {
    // An object type related to a domain model that can be stored in Core Data
    associatedtype Entity: NSManagedObject

    /// An initializer to create domain model with a given Core Data model
    ///
    /// - Parameter entity: An entity from Core Data.
    init?(entity: Entity)

    /// Creates an entity that can be stored by Core Data.
    ///
    /// - Parameter context: context that stores newly created model.
    /// - Returns: A model.
    func createEntity(context: NSManagedObjectContext) -> Entity
}
