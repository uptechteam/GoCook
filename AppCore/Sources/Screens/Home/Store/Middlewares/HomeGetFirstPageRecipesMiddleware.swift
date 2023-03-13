//
//  HomeGetRecipesMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 19.11.2022.
//

import Foundation

extension HomeViewController {
    static func makeGetFirstPageRecipesMiddleware(dependencies: Dependencies) -> Store.Middleware {
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
                    try await dependencies.searchRecipesFacade.getFirstPage(query: query)
                    guard !Task.isCancelled else {
                        return
                    }

                    await dispatch(.getRecipes(.success(())))
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
