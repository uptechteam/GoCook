//
//  LoginLoginMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import BusinessLogic
import Foundation

extension LoginViewController {
    static func makeLoginMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .loginTapped = action else {
                return
            }

            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                try await dependencies.profileFacade.login(username: state.name, password: state.password)
                await dispatch(.login(.success(())))
            } catch {
                await dispatch(.login(.failure(error)))
            }
        }
    }
}
