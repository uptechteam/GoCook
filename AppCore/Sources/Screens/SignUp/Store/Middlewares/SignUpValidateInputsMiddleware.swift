//
//  SignUpValidateInputsMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import DomainModels
import Foundation
import Helpers

extension SignUpViewController {

    static func makeValidateInputsMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .signUpTapped = action else {
                return
            }

            let name = state.name
            guard AppConstants.Validation.nameLengthRange ~= name.count else {
                await dispatch(.nameValidated(.failure(ValidationError.nameLength)))
                return
            }

            let password = state.password
            let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,50}$"
            let isValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
            await dispatch(.passwordValidated(isValid))
        }
    }
}
