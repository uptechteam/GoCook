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
    func isUnique(username: String) async throws -> Bool
    func login(username: String, password: String) async throws -> String
    func logout() async throws
    func refreshProfile() async throws -> Profile
    func signUp(username: String, password: String) async throws -> Profile
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

    public func isUnique(username: String) async throws -> Bool {
        let appRequest = try api.makeIsUniqueRequest(username: username)
        let response: IsUniqueResponse = try await networkClient.execute(appRequest)
        return response.isUnique
    }

    public func login(username: String, password: String) async throws -> String {
        let appRequest = try api.makeLoginRequest(username: username, password: password)
        let response: TokenResponse = try await networkClient.execute(appRequest)
        return response.token
    }

    public func logout() async throws {
        let appRequest = try api.makeLogoutRequest()
        let _: EmptyResponse = try await networkClient.execute(appRequest)
    }

    public func refreshProfile() async throws -> Profile {
        let appRequest = try api.makeRefreshProfileRequest()
        let response: ProfileResponse = try await networkClient.execute(appRequest)
        return response.domainModel
    }

    public func signUp(username: String, password: String) async throws -> Profile {
        let request = CreateUserRequest(username: username, password: password)
        let appRequest = try api.makeSignUpRequest(request: request)
        let response: ProfileResponse = try await networkClient.execute(appRequest)
        return response.domainModel
    }
}
