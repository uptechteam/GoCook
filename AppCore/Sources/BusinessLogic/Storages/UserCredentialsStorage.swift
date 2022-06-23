//
//  UserCredentialsStorage.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Helpers

public protocol UserCredentialsStoraging {
    func getAccessKey() -> String?
    func store(accessKey: String)
    func clear()
}

public final class UserCredentialsStorage: UserCredentialsStoraging {

    // MARK: - Properties

    private let storage: SecureStorage
    private var accessKey: String?

    // MARK: - Lifecycle

    public init(storage: SecureStorage) {
        self.storage = storage
        self.accessKey = (try? storage.getObject(forKey: Keys.credentials)).flatMap { $0 }
    }

    // MARK: - Public methods

    public func getAccessKey() -> String? {
        return accessKey
    }

    public func store(accessKey: String) {
        do {
            try storage.store(object: accessKey, forKey: Keys.credentials)
        } catch {
            log.error("Couldn't store an access key", metadata: ["error": .string(error.localizedDescription)])
        }

        self.accessKey = accessKey
    }

    public func clear() {
        do {
            try storage.removeItem(forKey: Keys.credentials)
        } catch {
            log.error("Couldn't clear a token", metadata: ["error": .string(error.localizedDescription)])
        }

        accessKey = nil
    }
}

private enum Keys {
    static let credentials = "UserCredentialsStorage.Credentials"
}
