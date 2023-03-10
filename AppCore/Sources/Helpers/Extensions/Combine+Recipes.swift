//
//  Combine+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine

public extension Publisher {
    func flatMapAsync<T>(
        _ transform: @escaping @Sendable (Output) async -> T
    ) -> Publishers.FlatMap<Publishers.FlatMap<T, Future<T, Never>>, Self> where T: Publisher, T.Failure == Never {
        flatMap { value in
            Future<T, Never> { promise in
                Task {
                    let publisher = await transform(value)
                    promise(.success(publisher))
                }
            }
            .flatMap { publisher in
                publisher
            }
        }
    }

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
