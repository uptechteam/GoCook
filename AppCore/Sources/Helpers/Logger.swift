//
//  Logger.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Foundation
import Logging
import os

public var log: Logging.Logger = {
    let osLogHandler = OSLogHandler(subsystem: "com.openergy", category: "data")
    let fileLogHandler = FileLogHandler()
    let multiplexLogHandler = MultiplexLogHandler([osLogHandler, fileLogHandler])
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
//        guard AppEnvironment.current.isFileLoggingEnabled else {
//            return
//        }

        let (emojiLevel, _) = getEmojiAndLogType(from: level)
        let filename = URL(string: file)?.lastPathComponent ?? file
        let detailsString = metadata.map {
            return "\n" + $0.map { pair in
                "\(pair.key): \(pair.value)"
            }
            .joined(separator: "\n")
        }

        let dateText = Date().description // DateFormatters.fullDateFormatter.string(from: Date())
        let message = "\(dateText) \(emojiLevel) [\(filename):\(line)] "
        + message.description
        + (detailsString ?? "")
        + "\n"

        FileLogHandler.logs += message
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

