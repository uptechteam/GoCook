//
//  ProfileResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels

struct ProfileResponse: Decodable {
    let id: String
    let username: String

    var domainModel: Profile {
        .init(
            id: .init(rawValue: id),
            username: username,
            avatar: nil
        )
    }
}
