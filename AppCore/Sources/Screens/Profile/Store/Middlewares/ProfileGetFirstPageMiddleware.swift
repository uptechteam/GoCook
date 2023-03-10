//
//  ProfileGetFirstPageMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import BusinessLogic
import DomainModels

extension ProfileViewController {
    static func makeGetFirstPageMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in
            let oldState = getState()
            await next(action)
            let state = getState()

            guard state.recipes.isLoading, !oldState.recipes.isLoading else {
                return
            }

            do {
                try await dependencies.profileRecipesFacade.getFirstPage()
                await dispatch(.getPage(.success(())))
            } catch {
                await dispatch(.getPage(.failure(error)))
            }
        }
    }
}
