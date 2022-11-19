//
//  HomeGetRecipesMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Foundation

extension HomeViewController {

    static func makeGetRecipesMiddleware(dependencies: Dependencies) -> Store.Middleware {
        var task: Task<(), Never>?
        return Store.makeMiddleware { dispatch, _, next, action in

            await next(action)
            guard case .searchQueryChanged(let query) = action else {
                return
            }

            task?.cancel()
            guard !query.isEmpty else {
                return
            }

            task = Task {
                do {
                    try await Task.sleep(nanoseconds: 400_000_000)
                    guard !Task.isCancelled else {
                        return
                    }

                    let recipes = try await dependencies.recipesClient.fetchRecipes(query: query)
                    guard !Task.isCancelled else {
                        return
                    }

                    await dispatch(.getRecipes(.success(recipes)))
                } catch {
                    guard !Task.isCancelled else {
                        return
                    }

                    await dispatch(.getRecipes(.failure(error)))
                }
            }
        }
    }
}
