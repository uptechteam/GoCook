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

    public let id: User.ID
    public let username: String
    public let avatar: ImageSource

    // MARK: - Lifecycle

    public init(id: User.ID, username: String, avatar: ImageSource) {
        self.id = id
        self.username = username
        self.avatar = avatar
    }
}
