//
//  SecureStorage.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Foundation
import KeychainAccess

public protocol SecureStorage: Storage {

}

public final class KeychainStorage: SecureStorage {

    // MARK: - Properties

    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    // MARK: - Lifecycle

    public init(storage: Storage) {
        let isStorageCleared: Bool = (try? storage.getBool(forKey: Keys.isKeychainCleared)).flatMap { $0 } ?? false
        if !isStorageCleared {
            try? clearStorage()
            try? storage.store(bool: true, forKey: Keys.isKeychainCleared)
        }
    }

    // MARK: - Public methods

    public func store(data: Data, forKey key: String) throws {
        try keychain.set(data, key: key)
    }

    public func getData(forKey key: String) throws -> Data? {
        return try keychain.getData(key)
    }

    public func clearStorage() throws {
        try keychain.removeAll()
    }

    public func removeItem(forKey key: String) throws {
        try keychain.remove(key)
    }
}

private enum Keys {
    static let isKeychainCleared = "Storage.HasClearedKeychain"
}
