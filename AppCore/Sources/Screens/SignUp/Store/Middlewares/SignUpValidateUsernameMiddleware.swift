//
//  SignUpValidateUsernameMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 04.07.2022.
//

import DomainModels
import Foundation
import Helpers

extension SignUpViewController {
    static func makeValidateUsernameMiddleware(dependencies: Dependencies) -> Store.Middleware {
        var task: Task<Void, Error>?
        return Store.makeMiddleware { dispatch, _, next, action in

            await next(action)

            guard case .nameChanged(let text) = action else {
                return
            }

            task?.cancel()
            guard text.count >= AppConstants.Validation.nameLengthRange.lowerBound else {
                await dispatch(.nameValidated(.success(true)))
                return
            }

            guard text.count <= AppConstants.Validation.nameLengthRange.upperBound else {
                await dispatch(.nameValidated(.failure(ValidationError.nameLength)))
                return
            }

            task = Task {
                do {
                    try await Task.sleep(nanoseconds: 200_000_000)
                    guard !Task.isCancelled else {
                        return
                    }

                    let isUnique = try await dependencies.profileFacade.isUnique(username: text)
                    if isUnique {
                        await dispatch(.nameValidated(.success(true)))
                    } else {
                        await dispatch(.nameValidated(.failure(ValidationError.notUniqueUsername)))
                    }
                } catch {
                    guard !Task.isCancelled else {
                        return
                    }

                    await dispatch(.nameValidated(.failure(error)))
                }
            }
        }
    }
}
