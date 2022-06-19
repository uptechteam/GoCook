//
//  Logger.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Foundation
import Sentry
import Logging
import os

var log: Logging.Logger = {
    let osLogHandler = OSLogHandler(subsystem: "com.openergy", category: "data")
    let sentryLogHandler = SentryLogHandler()
    let fileLogHandler = FileLogHandler()
    let multiplexLogHandler = MultiplexLogHandler([osLogHandler, sentryLogHandler, fileLogHandler])
    return Logging.Logger(label: "com.openergy", factory: { _ in multiplexLogHandler })
}()

struct FileLogHandler: LogHandler {
    var metadata = Logging.Logger.Metadata()
    var logLevel: Logging.Logger.Level = .debug
    static private(set) var logs: String = ""

    subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    // swiftlint:disable:next function_parameter_count
    func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        guard AppEnvironment.current.isFileLoggingEnabled else {
            return
        }

        let (emojiLevel, _) = getEmojiAndLogType(from: level)
        let filename = URL(string: file)?.lastPathComponent ?? file
        let detailsString = metadata.map {
            return "\n" + $0.map { pair in
                "\(pair.key): \(pair.value)"
            }
            .joined(separator: "\n")
        }

        let dateText = DateFormatters.fullDateFormatter.string(from: Date())
        let message = "\(dateText) \(emojiLevel) [\(filename):\(line)] "
        + message.description
        + (detailsString ?? "")
        + "\n"

        FileLogHandler.logs += message
    }
}

struct SentryLogHandler: LogHandler {
    var metadata = Logging.Logger.Metadata()
    var logLevel: Logging.Logger.Level = .warning

    subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    // swiftlint:disable:next function_parameter_count
    func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        // We want to filter out all non-critical events
        guard let sentrySeverity = makeSentrySeverity(from: level) else {
            return
        }

        var combinedMetadata = self.metadata
        if let overrideMetadata = metadata {
            combinedMetadata.merge(overrideMetadata, uniquingKeysWith: { $1 })
        }

        logSentryEvent(
            level: sentrySeverity,
            message: message.description,
            metadata: combinedMetadata
        )
    }

    private func makeSentrySeverity(from level: Logging.Logger.Level) -> SentryLevel? {
        switch level {
        case .critical:
            return .fatal

        case .error:
            return .error

        case .warning:
            return .warning

        default:
            return nil
        }
    }

    private func logSentryEvent(level: SentryLevel, message: String, metadata: [String: Any]?) {
        guard AppEnvironment.current.isErrorReportingEnabled else {
            return
        }

        SentrySDK.capture(message: message) { scope in
            scope.setEnvironment(AppEnvironment.current.name)
            scope.setExtras(metadata)
            scope.setLevel(level)
        }
    }
}

private final class OSLogHandler: LogHandler {
    private let osLog: OSLog

    var metadata = Logging.Logger.Metadata()
    var logLevel: Logging.Logger.Level = .debug

    init(subsystem: String, category: String) {
        self.osLog = OSLog(subsystem: subsystem, category: category)
    }

    subscript(metadataKey metadataKey: String) -> Logging.Logger.Metadata.Value? {
        get {
            metadata[metadataKey]
        }
        set(newValue) {
            metadata[metadataKey] = newValue
        }
    }

    // swiftlint:disable:next function_parameter_count
    func log(
        level: Logging.Logger.Level,
        message: Logging.Logger.Message,
        metadata: Logging.Logger.Metadata?,
        file: String,
        function: String,
        line: UInt
    ) {
        let (emojiLevel, osLogType) = getEmojiAndLogType(from: level)
        let filename = URL(string: file)?.lastPathComponent ?? file
        let detailsString = metadata.map {
            return "\n" + $0.map { pair in
                "\(pair.key): \(pair.value)"
            }
            .joined(separator: "\n")
        }

        os_log(
            "%@ [%@:%d] %{public}@%@",
            log: osLog,
            type: osLogType,
            emojiLevel,
            filename,
            line,
            message.description,
            detailsString ?? ""
        )
    }
}

private func getEmojiAndLogType(from level: Logging.Logger.Level) -> (String, OSLogType) {
    switch level {
    case .trace:
        return ("🖤", .debug)

    case .debug:
        return ("💚", .debug)

    case .info:
        return ("💙", .info)

    case .notice:
        return ("💜", .info)

    case .warning:
        return ("💛", .default)

    case .error:
        return ("❤️", .error)

    case .critical:
        return ("💔", .fault)
    }
}

