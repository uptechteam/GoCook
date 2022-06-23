//
//  PersistenceManaging.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import CoreData
import DomainModels
import Foundation
import Helpers

public protocol PersistenceManaging<DomainModel> {
    associatedtype DomainModel: PersistenceModel

    func store(models: [DomainModel])
    func getModels() -> [DomainModel]
    func clear(filter: Filter)
}

extension PersistenceManaging {
    func clear() {
        clear(filter: Filter(predicates: []))
    }
}

public final class PersistenceManager<DModel: PersistenceModel>: PersistenceManaging {

    public typealias DomainModel = DModel


    // MARK: - Properties

    private let persistentContainer: NSPersistentContainer
    private let entityName: String

    // MARK: - Lifecycle

    public init(containerName: String, entityName: String) {
        guard
            let modelURL = Bundle.module.url(forResource: containerName, withExtension: "momd"),
            let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("Can't initialize PersisntentManager")
        }

        self.persistentContainer = NSPersistentContainer(name: containerName, managedObjectModel: managedObjectModel)
        self.entityName = entityName
        loadContainer()
    }

    // MARK: - Public methods

    public func store(models: [DModel]) {
        guard Thread.isMainThread else {
            log.error("Can't store models on background thread.")
            return
        }

        let context = persistentContainer.viewContext
        models.forEach { model in
            _ = model.createEntity(context: context)
        }
        do {
            try context.save()
            context.reset()
        } catch {
            log.error("Can't store models", metadata: ["error": .string(error.localizedDescription)])
        }
    }

    public func getModels() -> [DModel] {
        guard Thread.isMainThread else {
            log.error("Can't fetch models on background thread.")
            return []
        }

        let fetchRequest = NSFetchRequest<DomainModel.Entity>(entityName: entityName)
        let context = persistentContainer.viewContext
        do {
            let models = try context.fetch(fetchRequest)
            return models.compactMap(DomainModel.init(entity:))
        } catch {
            log.error("Can't get models", metadata: ["error": .string(error.localizedDescription)])
            return []
        }
    }

    public func clear(filter: Filter) {
        guard Thread.isMainThread else {
            log.error("Can't clear data on background thread.")
            return
        }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if !filter.predicates.isEmpty {
            fetchRequest.predicate = NSPredicate(
                format: filter.makePredicateExpression(),
                argumentArray: filter.getArguments()
            )
        }
        let context = persistentContainer.viewContext
        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(request)
            context.reset()
        } catch {
            log.error("Can't clear data", metadata: ["error": .string(error.localizedDescription)])
        }
    }

    // MARK: Private methods

    private func loadContainer() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
}
