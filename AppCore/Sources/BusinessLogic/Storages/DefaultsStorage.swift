//
//  DefaultsStorage.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Foundation

extension UserDefaults: Storage {
    public func getData(forKey key: String) throws -> Data? {
        return object(forKey: key) as? Data
    }

    public func store(data: Data, forKey key: String) throws {
        set(data, forKey: key)
    }

    public func removeItem(forKey key: String) throws {
        set(nil, forKey: key)
    }

    public func clearStorage() throws {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return
        }

        removePersistentDomain(forName: bundleID)
    }

    public static func resolve() -> UserDefaults {
        .standard
    }
}
