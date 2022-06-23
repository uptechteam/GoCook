//
//  ProfileLogoutMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import Helpers

extension ProfileViewController {

    static func makeLogoutMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)

            guard case .logout = action else {
                return
            }

            do {
                try await dependencies.profileFacade.logout()
            } catch {
                log.error("Error: \(error)")
            }
        }
    }
}
