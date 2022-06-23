//
//  ProfileLoginMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import BusinessLogic
import Helpers

extension ProfileViewController {

    static func makeLoginMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)

            guard case .login = action else {
                return
            }

            do {
                try await dependencies.profileFacade.login(username: "Master Chief", password: "password")
            } catch {
                log.debug("Error: \(error.localizedDescription)")
            }
        }
    }
}
