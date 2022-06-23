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
        path: String,
        authorisation: Authorisation = .basic
    ) throws -> AppRequest {
        let request = try URLRequest(
            url: baseURL.appendingPathComponent(path),
            method: .delete,
            headers: .default
        )
        return AppRequest(urlRequest: request, authorisation: authorisation)
    }

    func makeGetTarget(
        path: String,
        parameters: [String: String] = [:],
        authorisation: Authorisation = .basic
    ) throws -> AppRequest {
        var request = try URLRequest(
            url: baseURL.appendingPathComponent(path),
            method: .get,
            headers: .default
        )
        request = try URLEncodedFormParameterEncoder.default.encode(parameters, into: request)
        return AppRequest(urlRequest: request, authorisation: authorisation)
    }

    func makePostTarget(
        path: String,
        parameters: [String: String] = [:],
        authorisation: Authorisation = .basic
    ) throws -> AppRequest {
        var request = try URLRequest(
            url: baseURL.appendingPathComponent(path),
            method: .post,
            headers: .default
        )
        request = try URLEncodedFormParameterEncoder.default.encode(parameters, into: request)
        return AppRequest(urlRequest: request, authorisation: authorisation)
    }
}
