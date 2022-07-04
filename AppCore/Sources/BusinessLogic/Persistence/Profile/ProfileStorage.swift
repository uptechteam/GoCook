//
//  ProfileStorage.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import CoreData
import DomainModels

/**
 A class is responsible to store, retrieve and clear profile.

 Use this class to persistantly store `Profile`, retrieve and clear.
 Requirements:
 * Provide ability to store `Profile` across sessions.
 * Provide ability to retrieve `Profile`.
 * Provide ability to clear `Profile`.
 */
public protocol ProfileStoraging {
    /// Store `Profile` in storage. It will update existing model if there is.
    ///
    /// - Parameter profile: `Profile` object.
    func store(profile: Profile) async
    /// Retrieve `Profile` from storage.
    ///
    /// - Returns: `Profile` or nil if storage doesn't have the object.
    func getProfile() async -> Profile?
    /// Remove `Profile` object from storage.
    func clear() async
}

public final class ProfileStorage: ProfileStoraging {

    // MARK: - Properties

    private let persistenceManager: PersistenceManager<Profile>

    // MARK: - Lifecycle

    public init(persistenceManager: PersistenceManager<Profile>) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - Public methods

    public func store(profile: Profile) async {
        await persistenceManager.clear()
        await persistenceManager.store(models: [profile])
    }

    public func getProfile() async -> Profile? {
        await persistenceManager.getModels().first
    }

    public func clear() async {
        await persistenceManager.clear()
    }
}

// MARK: - Constants

extension ProfileStorage {
    enum Constants {
        static let containerName = "PersistentProfile"
        static let entityName = "PersistentProfile"
    }
}
