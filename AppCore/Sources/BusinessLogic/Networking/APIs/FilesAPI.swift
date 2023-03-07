//
//  FilesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation

struct FilesAPI {

    // MARK: - Properties

    private let requestBuilder: RequestBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.requestBuilder = RequestBuilder(baseURL: baseURL.appendingPathComponent("files"))
    }

    // MARK: - Public methods

    func makePostAvatarImageRequest(data: Data) throws -> AppRequest {
        try requestBuilder.makePostDataRequest(path: "avatar", data: data, authorisation: .bearer)
    }

    func makePostRecipeImageRequest(data: Data) throws -> AppRequest {
        try requestBuilder.makePostDataRequest(path: "recipe", data: data, authorisation: .bearer)
    }
}
