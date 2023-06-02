//
//  ProfileUpdate.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

public struct ProfileUpdate: Equatable {

    // MARK: - Properties

    public let avatarURL: String?
    public let deleteAvatar: Bool
    public let username: String?

    // MARK: - Lifecycle

    public init(avatarURL: String?, deleteAvatar: Bool, username: String?) {
        self.avatarURL = avatarURL
        self.deleteAvatar = deleteAvatar
        self.username = username
    }
}
