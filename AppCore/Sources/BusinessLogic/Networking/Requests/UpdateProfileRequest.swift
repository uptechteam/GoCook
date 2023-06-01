//
//  UpdateProfileRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import DomainModels
import Foundation

struct UpdateProfileRequest: Encodable {

    // MARK: - Properties

    let avatarURL: String?
    let deleteAvatar: Bool?
    let username: String?

    // MARK: - Lifecycle

    init(update: ProfileUpdate) {
        self.avatarURL = update.avatarURL
        if update.deleteAvatar {
            self.deleteAvatar = true
        }

        self.username = update.username
    }
}
