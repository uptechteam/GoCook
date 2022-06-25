//
//  ProfileClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import DomainModels
import Foundation
import Helpers

public protocol ProfileClienting {
    func login(username: String, password: String) async throws -> String
    func logout() async throws
    func refreshProfile() async throws -> Profile
}

public final class ProfileClient: ProfileClienting {

    // MARK: - Properties

    private let api: UsersAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = UsersAPI(baseURL: AppEnvironment.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func login(username: String, password: String) async throws -> String {
        let appRequest = try api.makeLoginTarget(username: username, password: password)
        let response: TokenResponse = try await networkClient.request(appRequest)
        return response.token
    }

    public func logout() async throws {
        let appRequest = try api.makeLogoutTarget()
        let _: EmptyResponse = try await networkClient.request(appRequest)
    }

    public func refreshProfile() async throws -> Profile {
        let appRequest = try api.makeRefreshProfileTarget()
        let response: ProfileResponse = try await networkClient.request(appRequest)
        return response.domainModel
    }
}
