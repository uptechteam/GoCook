//
//  FileClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import DomainModels
import Foundation
import Helpers

public protocol FileClienting {
    func uploadAvatar(data: Data) async throws -> String
    func uploadRecipeImage(data: Data) async throws -> String
}

public final class FileClient: FileClienting {

    // MARK: - Properties

    private let api: FilesAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = FilesAPI(baseURL: AppEnvironment.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func uploadAvatar(data: Data) async throws -> String {
        let request = try api.makePostAvatarImageRequest(data: data)
        let response: AvatarURLResponse = try await networkClient.execute(request)
        return response.avatarURL
    }

    public func uploadRecipeImage(data: Data) async throws -> String {
        let request = try api.makePostRecipeImageRequest(data: data)
        let response: ImageURLResponse = try await networkClient.execute(request)
        return response.imageURL
    }
}
