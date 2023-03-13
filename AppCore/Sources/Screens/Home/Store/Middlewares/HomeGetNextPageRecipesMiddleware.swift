//
//  HomeGetNextPageRecipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Foundation

extension HomeViewController {
    static func makeGetNextPageRecipesMiddleware(dependencies: Dependencies) -> Store.Middleware {
        var task: Task<(), Never>?
        return Store.makeMiddleware { dispatch, getState, next, action in
            await next(action)
            let state = getState()
            switch action {
            case .searchQueryChanged:
                task?.cancel()
                return

            case .scrolledSearchToEnd:
                break

            default:
                return
            }

            let query = state.searchQuery
            task?.cancel()
            guard !query.isEmpty else {
                return
            }

            task = Task {
                do {
                    try await dependencies.searchRecipesFacade.getNextPage(query: query)
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
