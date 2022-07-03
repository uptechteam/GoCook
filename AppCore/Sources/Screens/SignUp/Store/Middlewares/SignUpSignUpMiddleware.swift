//
//  SignUpSignUpMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import BusinessLogic
import Foundation

extension SignUpViewController {

    static func makeSignUpMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .signUpTapped = action else {
                return
            }

            do {
                try await dependencies.profileFacade.signUp(username: state.name, password: state.password)
                await dispatch(.signUp(.success(())))
            } catch {
                await dispatch(.signUp(.failure(error)))
            }
        }
    }
}
