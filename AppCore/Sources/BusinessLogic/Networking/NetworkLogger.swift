//
//  NetworkLogger.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Foundation
import Helpers

struct NetworkLogger {
    func log(error: Error) {
        Helpers.log.info("HTTP Request failed", metadata: ["Error description": .string(error.localizedDescription)])
    }

    func log(request description: String) {
        Helpers.log.info("Sending HTTP Request", metadata: ["Request": .string(description)])
    }

    func log(response data: Data, request: AppRequest) {
        let requestDescription = request.urlRequest?.description ?? "Unknown request"
        let responseSize = data.count
        let formattedData = (try? JSONSerialization.jsonObject(with: data, options: []))
            .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted]) }
            .flatMap { String(data: $0, encoding: .utf8) }
        ?? String(data: data, encoding: .utf8)
        ?? "unknown"
        Helpers.log.info(
            "Received HTTP Response",
            metadata: [
                "1. Size": .string("\(responseSize) B"),
                "2. Response": .string("\(requestDescription) \(formattedData.prefix(5000))")
            ]
        )
    }
}
