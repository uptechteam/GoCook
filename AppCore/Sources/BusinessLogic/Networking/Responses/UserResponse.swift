//
//  UserResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import DomainModels
import Foundation
import Helpers

struct UserResponse: Decodable {
    let avatarURL: URL?
    let id: String
    let username: String

    var domainModel: User {
        return .init(
            avatar: avatarURL.flatMap(ImageSource.remote) ?? .asset(nil),
            id: User.ID(rawValue: id),
            username: username
        )
    }
}
