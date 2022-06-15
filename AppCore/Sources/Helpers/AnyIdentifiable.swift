//
//  AnyIdentifiable.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

public struct AnyIdentifiable<T>: Identifiable {

    // MARK: - Proeprties

    public let id: UUID
    public let value: T

    // MARK: - Lifecycle

    public init(value: T) {
        self.id = UUID()
        self.value = value
    }
}

extension AnyIdentifiable: Equatable {
    public static func == (lhs: AnyIdentifiable<T>, rhs: AnyIdentifiable<T>) -> Bool {
        lhs.id == rhs.id
    }
}
