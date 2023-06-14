//
//  SentryConfigurator.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2023.
//

import Helpers
import Sentry

public protocol SentryConfigurating {
    func configure()
}

public final class SentryConfigurator: SentryConfigurating {

    // MARK: - Lifecycle

    public init() {

    }

    // MARK: - Public methods

    public func configure() {
        guard AppSettings.current.isErrorReportingEnabled else {
            return
        }

        SentrySDK.start { options in
            options.dsn = AppSecrets.current.sentryDSN
            options.enableMetricKit = true
            options.enableWatchdogTerminationTracking = false
            options.environment = AppSettings.current.name
        }
    }
}
