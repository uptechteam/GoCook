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
    let avatarURL: String?
    let id: String
    let username: String

    var domainModel: User {
        let avatarImageURL = avatarURL.flatMap { avatarURL in
            AppEnvironment.current.baseURL.appendingPathComponent("files/avatar/\(avatarURL)")
        }
        return .init(
            avatar: avatarImageURL.flatMap(ImageSource.remote),
            id: User.ID(rawValue: id),
            username: username
        )
    }
}
