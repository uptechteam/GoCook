//
//  Combine+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine

public extension Publisher {
    func mapAsync<T>(
        _ transform: @escaping @Sendable (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    promise(.success(await transform(value)))
                }
            }
        }
    }
}
