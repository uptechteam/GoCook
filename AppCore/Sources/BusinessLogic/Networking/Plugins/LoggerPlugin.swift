//
//  LoggerPlugin.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Foundation
import Moya

final class LoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let urlRequest = request.request else {
            return
        }

        log.info("Sending HTTP Request", metadata: ["request": .string(urlRequest.curlString)])
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            let requestDescription = response.request?.description ?? "Unknown request"
            let responseSize = response.data.count
            let formattedData = (try? JSONSerialization.jsonObject(with: response.data, options: []))
                .flatMap { try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted]) }
                .flatMap { String(data: $0, encoding: .utf8) }
            ?? String(data: response.data, encoding: .utf8)
            ?? "unknown"
            log.info(
                "Received HTTP Response (size \(responseSize / 1024) KB",
                metadata: [
                    "response": .string("\(requestDescription) [\(response.statusCode)] \(formattedData.prefix(5000))")
                ]
            )

        case .failure(let error):
            let content = error.response.flatMap({ String(data: $0.data, encoding: .utf8) }) ?? ""
            let reason = error.localizedDescription
            log.info("HTTP Request failed", metadata: [
                "response": .string("\(content) Reason: \(reason)")
            ])
        }
    }
}

private extension URLRequest {
    var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                let limitedValue = value.count > 100 ? value.prefix(100) + "..." : value
                command.append("-H '\(key): \(limitedValue)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        return command.joined(separator: " \\\n\t")
    }
}

