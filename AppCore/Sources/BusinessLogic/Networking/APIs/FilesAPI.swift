//
//  FilesAPI.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Foundation

struct FilesAPI {

    // MARK: - Properties

    private let targetBuilder: TargetBuilder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.targetBuilder = TargetBuilder(baseURL: baseURL.appendingPathComponent("files"))
    }

    // MARK: - Public methods

    func makePostAvatarImageTarget(data: Data) throws -> AppRequest {
        try targetBuilder.makePostDataTarget(path: "avatar", data: data, authorisation: .bearer)
    }

    func makePostRecipeImageTarget(data: Data) throws -> AppRequest {
        try targetBuilder.makePostDataTarget(path: "recipe", data: data, authorisation: .bearer)
    }
}
