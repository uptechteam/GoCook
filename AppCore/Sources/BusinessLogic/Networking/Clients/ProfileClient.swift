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
    func update(profile: ProfileUpdate) async throws -> Profile
}

public final class ProfileClient: ProfileClienting {

    // MARK: - Properties

    private let api: UsersAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = UsersAPI(baseURL: AppSettings.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func isUnique(username: String) async throws -> Bool {
        let request = try api.makeGetIsUniqueRequest(username: username)
        let response: IsUniqueResponse = try await networkClient.execute(request)
        return response.isUnique
    }

    public func login(username: String, password: String) async throws -> String {
        let request = try api.makePostLoginRequest(username: username, password: password)
        let response: TokenResponse = try await networkClient.execute(request)
        return response.token
    }

    public func logout() async throws {
        let request = try api.makeDeleteLogoutRequest()
        let _: EmptyResponse = try await networkClient.execute(request)
    }

    public func refreshProfile() async throws -> Profile {
        let request = try api.makeGetProfileRequest()
        let response: ProfileResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func signUp(username: String, password: String) async throws -> Profile {
        let request = try api.makePostSignUpRequest(username: username, password: password)
        let response: ProfileResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func update(profile: ProfileUpdate) async throws -> Profile {
        let request = try api.makePutProfileRequest(update: profile)
        let response: ProfileResponse = try await networkClient.execute(request)
        return response.domainModel
    }
}
