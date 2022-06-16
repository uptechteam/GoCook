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

    public let id: User.ID
    public let username: String
    public let avatar: ImageSource

    // MARK: - Lifecycle

    public init(id: ID, username: String, avatar: ImageSource) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
