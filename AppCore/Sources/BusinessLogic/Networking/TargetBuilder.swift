//
//  TargetBuilder.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Alamofire
import Helpers
import Foundation

struct TargetBuilder {

    // MARK: - Properties

    private let baseURL: URL
    private let encoder: JSONEncoder

    // MARK: - Lifecycle

    init(baseURL: URL) {
        self.baseURL = baseURL
        self.encoder = JSONDateEncoder()
    }

    // MARK: - Public methods

    func makeDeleteTarget(
        path: String
    ) throws -> AppRequest {
        return try URLRequest(
            url: baseURL.appendingPathExtension(path),
            method: .delete,
            headers: .default
        )
    }

    func makeGetTarget(
        path: String,
        parameters: [String: String]
    ) throws -> AppRequest {
        let request = try URLRequest(
            url: baseURL.appendingPathExtension(path),
            method: .get,
            headers: [.defaultAcceptEncoding, .defaultAcceptLanguage, .defaultUserAgent, .authorization("Basic dXNlcm5hbWU6c2VjcmV0")]
        )
        return try URLEncodedFormParameterEncoder.default.encode(parameters, into: request)
    }

    func makePostTarget(
        path: String,
        parameters: [String: String]
    ) throws -> AppRequest {
        let request = try URLRequest(
            url: baseURL.appendingPathExtension(path),
            method: .post,
            headers: .default
        )
        return try URLEncodedFormParameterEncoder.default.encode(parameters, into: request)
    }
}
