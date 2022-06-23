//
//  UserResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels

struct UserResponse: Decodable {
    let id: String
    let username: String

    var domainModel: Profile {
        .init(
            id: .init(rawValue: id),
            username: username,
            avatar: .asset(nil)
        )
    }
}
