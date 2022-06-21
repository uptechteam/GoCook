//
//  NetworkClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Alamofire
import Foundation
import Helpers

public protocol NetworkClient {
    func request<Response: Decodable>(_ request: AppRequest) async throws -> Response
}

public final class NetworkClientImpl: NetworkClient {

    // MARK: - Properties

    private let logger: NetworkLogger

    // MARK: - Lifecycle

    public init() {
        self.logger = NetworkLogger()
    }

    // MARK: - Public methods

    public func request<Response: Decodable>(_ request: AppRequest) async throws -> Response {
        do {
            let responseData = try await AF.request(request)
                .cURLDescription(calling: logger.log)
                .validate(statusCode: 200..<300)
                .serializingData()
                .value
            logger.log(response: responseData, request: request)
            let response = try JSONDateDecoder().decode(Response.self, from: responseData)
            return response
        } catch {
            logger.log(error: error)
            throw error
        }
    }
}
