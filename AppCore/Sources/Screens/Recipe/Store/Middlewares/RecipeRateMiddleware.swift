//
//  RecipeRateMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.12.2022.
//

import DomainModels
import Foundation

extension RecipeViewController {

    static func makeRateMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, _, next, action in

            await next(action)

            guard case .starTapped(let index) = action else {
                return
            }

            do {
                let rating = index + 1
                try await dependencies.recipeFacade.rate(rating: rating)
                await dispatch(.rate(.success(())))
            } catch {
                await dispatch(.rate(.failure(error)))
            }
        }
    }
}
