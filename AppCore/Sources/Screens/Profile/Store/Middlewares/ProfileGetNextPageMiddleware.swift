//
//  ProfileGetNextPageMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import BusinessLogic
import DomainModels

extension ProfileViewController {
    static func makeGetNextPageMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, _, next, action in
            await next(action)

            guard case .scrolledToEnd = action else {
                return
            }

            do {
                try await dependencies.profileRecipesFacade.getNextPage()
                await dispatch(.getPage(.success(())))
            } catch {
                await dispatch(.getPage(.failure(error)))
            }
        }
    }
}
