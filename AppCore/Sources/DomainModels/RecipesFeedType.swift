//
//  RecipesFeedType.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Foundation

public enum RecipesFeedType: Equatable {

    case profile(User.ID?)
    case search
    case user(User.ID)

    // MARK: - Properties

    public var isProfile: Bool {
        switch self {
        case .profile:
            return true

        default:
            return false
        }
    }
}
