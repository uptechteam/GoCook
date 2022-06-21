//
//  HomeGetFeedMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Foundation

extension HomeViewController {

    static func makeGetFeedMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)

            guard case .getFeed(.trigger) = action else {
                return
            }

            do {
                let recipes = try await dependencies.recipesClient.getRecipes()
                await dispatch(.getFeed(.success(recipes)))
            } catch {
                await dispatch(.getFeed(.failure(error)))
            }
        }
    }
}
