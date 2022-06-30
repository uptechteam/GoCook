//
//  CreateRecipeUploadImageMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation
import Helpers

extension CreateRecipeViewController {

    static func makeUploadImageMiddleware(dependencies: Dependencies) -> Store.Middleware {

        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)

            guard case .imagePicked(let imageSource) = action else {
                return
            }

            guard let data = imageSource.image?.pngData() else {
                log.info("Can't get data from picked image")
                return
            }

            do {
                let imageURL = try await dependencies.fileClient.uploadRecipeImage(data: data)
                await dispatch(.uploadImage(.success(imageURL)))
            } catch {
                await dispatch(.uploadImage(.failure(error)))
            }
        }
    }
}
