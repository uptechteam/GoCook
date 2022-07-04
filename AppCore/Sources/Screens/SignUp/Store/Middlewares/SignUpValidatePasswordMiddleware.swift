//
//  SignUpValidatePasswordMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import Foundation

extension SignUpViewController {

    static func makeValidatePasswordMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .signUpTapped = action else {
                return
            }

            let password = state.password
            let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,50}$"
            let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
            await dispatch(.passwordValidated(isValid))
        }
    }
}
