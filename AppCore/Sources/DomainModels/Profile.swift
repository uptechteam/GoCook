//
//  Profile.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.06.2022.
//

import CoreData
import Helpers

public struct Profile: Equatable {

    // MARK: Properties

    public typealias ID = Tagged<Profile, String>

    public let id: ID
    public let username: String
    public let avatar: ImageSource

    // MARK: - Lifecycle

    public init(id: ID, username: String, avatar: ImageSource) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
