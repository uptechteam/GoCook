//
//  ToSyncClosure.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Foundation

public func toSyncClosure<T>(callback: @escaping @Sendable (T) async -> Void) -> ((T) -> Void) {
    return { argument in
        Task {
            await callback(argument)
        }
    }
}

public func toSyncClosure(callback: @escaping @Sendable () async -> Void) -> (() -> Void) {
    return {
        Task {
            await callback()
        }
    }
}
