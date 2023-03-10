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
            let oldState = getState()
            await next(action)
            let state = getState()

            guard state.recipeCategories.isLoading, !oldState.recipeCategories.isLoading else {
                return
            }

            do {
                let recipes = try await dependencies.recipesClient.fetchFeed()
                await dispatch(.getFeed(.success(recipes)))
            } catch {
                await dispatch(.getFeed(.failure(error)))
            }
        }
    }
}
