//
//  ProfileFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Combine
import DomainModels
import Helpers

public protocol ProfileFacading {
    /// Publisher that emits `Profile` each time it is changed
    var profile: AnyPublisher<Profile?, Never> { get }

    func getProfile() -> Profile
    func login(username: String, password: String) async throws
    func logout() async
}

public final class ProfileFacade: ProfileFacading {

    // MARK: - Properties

    private let profileClient: ProfileClienting
    private let profileStorage: ProfileStoraging
    private let userCredentialsStorage: UserCredentialsStoraging
    private let profileSubject: CurrentValueSubject<Profile?, Never>

    public var profile: AnyPublisher<Profile?, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(
        profileClient: ProfileClienting,
        profileStorage: ProfileStoraging,
        userCredentialsStorage: UserCredentialsStoraging
    ) {
        self.profileClient = profileClient
        self.profileStorage = profileStorage
        self.userCredentialsStorage = userCredentialsStorage
        self.profileSubject = CurrentValueSubject(nil)
        Task {
            await loadProfile()
        }
    }

    // MARK: - Public methods

    public func getProfile() -> Profile {
        profileSubject.value!
    }

    public func login(username: String, password: String) async throws {
        let token = try await profileClient.login(username: username, password: password)
        userCredentialsStorage.store(accessKey: token)
        let profile = try await profileClient.refreshProfile()
        await profileStorage.store(profile: profile)
        profileSubject.send(profile)
    }

    public func logout() async {
        do {
            try await profileClient.logout()
        } catch {
            log.error("Logout error", metadata: ["Description": .string(error.localizedDescription)])
        }
        await profileStorage.clear()
        userCredentialsStorage.clear()
        profileSubject.send(nil)
    }

    // MARK: - Private methods

    private func loadProfile() async {
        guard let profile = await profileStorage.getProfile() else {
            return
        }

        profileSubject.send(profile)
    }
}
