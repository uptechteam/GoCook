//
//  ProfileResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels
import Helpers

struct ProfileResponse: Decodable {
    let avatarURL: String?
    let id: String
    let username: String

    var domainModel: Profile {
        let avatarImageURL = avatarURL.flatMap { avatarURL in
            AppEnvironment.current.baseURL.appendingPathComponent("files/avatar/\(avatarURL)")
        }
        return .init(
            id: .init(rawValue: id),
            username: username,
            avatar: avatarImageURL.flatMap(ImageSource.remote)
        )
    }
}
