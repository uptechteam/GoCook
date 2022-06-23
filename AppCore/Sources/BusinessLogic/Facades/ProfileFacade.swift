//
//  ProfileFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import Combine
import DomainModels

public protocol ProfileFacading {
    /// Publisher that emits `Profile` each time it is changed
    var profile: AnyPublisher<Profile?, Never> { get }

    func getProfile() -> Profile
    func login(username: String, password: String) async throws
    func logout() async throws
}

public final class ProfileFacade: ProfileFacading {

    // MARK: - Properties

    private let profileClient: ProfileClienting
    private let userCredentialsStorage: UserCredentialsStoraging
    private let profileSubject: CurrentValueSubject<Profile?, Never>

    public var profile: AnyPublisher<Profile?, Never> {
        profileSubject.eraseToAnyPublisher()
    }

    // MARK: - Lifecycle

    public init(profileClient: ProfileClienting, userCredentialsStorage: UserCredentialsStoraging) {
        self.profileClient = profileClient
        self.userCredentialsStorage = userCredentialsStorage
        self.profileSubject = CurrentValueSubject(nil)
    }

    // MARK: - Public methods

    public func getProfile() -> Profile {
        profileSubject.value!
    }

    public func login(username: String, password: String) async throws {
        let token = try await profileClient.login()
        userCredentialsStorage.store(accessKey: token)
        print(token)
    }

    public func logout() async throws {
        try await profileClient.logout()
        userCredentialsStorage.clear()
    }
}
