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
    func uploadAvatar(data: Data) async throws -> Profile
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

    public func uploadAvatar(data: Data) async throws -> Profile {
        let appRequest = try api.makePostAvatarImageTarget(data: data)
        let response: ProfileResponse = try await networkClient.execute(appRequest)
        return response.domainModel
    }

    public func uploadRecipeImage(data: Data) async throws -> String {
        let appRequest = try api.makePostRecipeImageTarget(data: data)
        let response: ImageURLResponse = try await networkClient.execute(appRequest)
        return response.imageURL
    }
}
