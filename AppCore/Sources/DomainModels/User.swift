//
//  User.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Helpers

public struct User: Equatable {

    // MARK: - Properties

    public typealias ID = Tagged<User, String>

    public let avatar: ImageSource
    public let id: User.ID
    public let username: String

    // MARK: - Lifecycle

    public init(avatar: ImageSource, id: ID, username: String) {
        self.avatar = avatar
        self.id = id
        self.username = username
    }
}
