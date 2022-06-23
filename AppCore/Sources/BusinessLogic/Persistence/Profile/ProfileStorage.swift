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
    func store(profile: Profile)
    /// Retrieve `Profile` from storage.
    ///
    /// - Returns: `Profile` or nil if storage doesn't have the object.
    func getProfile() -> Profile?
    /// Remove `Profile` object from storage.
    func clear()
}

public final class ProfileStorage: ProfileStoraging {

    // MARK: - Properties

    private let persistenceManager: any PersistenceManaging<Profile>

    // MARK: - Lifecycle

    public init(persistenceManager: any PersistenceManaging<Profile>) {
        self.persistenceManager = persistenceManager
    }

    // MARK: - Public methods

    public func store(profile: Profile) {
        persistenceManager.clear()
        persistenceManager.store(models: [profile])
    }

    public func getProfile() -> Profile? {
        persistenceManager.getModels().first
    }

    public func clear() {
        persistenceManager.clear()
    }
}

// MARK: - Constants

extension ProfileStorage {
    enum Constants {
        static let containerName = "PersistentProfile"
        static let entityName = "PersistentProfile"
    }
}
