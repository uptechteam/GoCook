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

        var task: Task<String, Error>?
        return Store.makeMiddleware { dispatch, getState, next, action in

            let oldState = getState()
            await next(action)

            func upload(imageSource: ImageSource) async throws -> String? {
                guard let data = imageSource.image?.pngData() else {
                    log.info("Can't get data from picked image")
                    return nil
                }

                let uploadTask = Task {
                    return try await dependencies.fileClient.uploadRecipeImage(data: data)
                }
                task = uploadTask
                let imageID = try await uploadTask.value
                return uploadTask.isCancelled ? nil : imageID
            }

            switch action {
            case .imagePicked(let imageSource):
                do {
                    guard let imageID = try await upload(imageSource: imageSource) else {
                        return
                    }

                    await dispatch(.uploadImage(.success(imageID)))
                } catch {
                    await dispatch(.uploadImage(.failure(error)))
                }

            case .recipeImageTapped where oldState.stepOneState.recipeImageState.isUploading:
                task?.cancel()

            default:
                break
            }
        }
    }
}
