//
//  StorageEnvelope.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Foundation

public struct StorageEnvelope<T: Codable>: Codable {

    // MARK: - Properties

    public let value: T

    // MARK: - Lifecycle

    public init(value: T) {
        self.value = value
    }
}
