//
//  AppNotification.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Foundation

public enum AppNotificationType {
    case logout
    case notificationsToken
    case unauthorizedError

    public var name: String {
        switch self {
        case .logout:
            return "com.gocook.app_notification.logout"

        case .notificationsToken:
            return "com.gocook.app_notifications.token"

        case .unauthorizedError:
            return "com.gocook.app_notification.unauthorized.error"
        }
    }

    public var notificationName: Notification.Name {
        Notification.Name(name)
    }
}
