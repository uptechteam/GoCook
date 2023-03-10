//
//  AppNotification.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Foundation

public struct AppNotification {

    // MARK: - Properties

    public let type: AppNotificationType
    public let userInfo: [AnyHashable: Any]

    // MARK: - Lifecycle

    public init(type: AppNotificationType, userInfo: [AnyHashable: Any] = [:]) {
        self.type = type
        self.userInfo = userInfo
    }

    // MARK: - Public methods

    public static func makeNotification(_ notification: AppNotification) -> Notification {
        return Notification(
            name: notification.type.notificationName,
            object: nil,
            userInfo: notification.userInfo
        )
    }
}

// MARK: - Keys

public extension AppNotification {
    enum Keys {
        static let notificationToken = "notification_token"
        static let notificationTokenData = "notification_token_data"
        static let notificationLogoutIsForced = "notification_logout_if_forced"
    }
}
