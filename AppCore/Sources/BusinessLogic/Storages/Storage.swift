//
//  Storage.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels
import Foundation
import Helpers

public protocol Storage {
    func store(data: Data, forKey key: String) throws
    func getData(forKey key: String) throws -> Data?
    func clearStorage() throws
    func removeItem(forKey key: String) throws
}

extension Storage {
    public func getObject<T: Codable>(forKey key: String) throws -> T? {
        guard let data = try getData(forKey: key) else {
            return nil
        }

        return try? JSONDateDecoder().decode(T.self, from: data)
    }

    public func store<T: Codable>(object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        return try store(data: data, forKey: key)
    }

    public func store(bool: Bool, forKey key: String) throws {
        try store(object: StorageEnvelope(value: bool), forKey: key)
    }

    public func getBool(forKey key: String) throws -> Bool? {
        let decodedEnvelope: StorageEnvelope<Bool>? = try getObject(forKey: key)
        return decodedEnvelope?.value
    }

    public func storePrimitive<T: Codable>(value: T, forKey key: String) throws {
        try store(object: StorageEnvelope(value: value), forKey: key)
    }

    public func getPrimitive<T: Codable>(forKey key: String) throws -> T? {
        let decodedEnvelope: StorageEnvelope<T>? = try getObject(forKey: key)
        return decodedEnvelope?.value
    }
}
