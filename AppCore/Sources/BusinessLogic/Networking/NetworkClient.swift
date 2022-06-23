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
    private let basicAuthentication: BasicAuthentication
    private let bearerAuthentication: BearerAuthentication

    // MARK: - Lifecycle

    public init(userCrenetialsStorage: UserCredentialsStoraging) {
        self.logger = NetworkLogger()
        self.basicAuthentication = BasicAuthentication()
        self.bearerAuthentication = BearerAuthentication(userCrenetialsStorage: userCrenetialsStorage)
    }

    // MARK: - Public methods

    public func request<Response: Decodable>(_ request: AppRequest) async throws -> Response {
        do {
            let interceptor = createInterceptor(for: request.authorisation)
            let responseData = try await AF.request(request.urlRequest, interceptor: interceptor)
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

    // MARK: - Private methods

    private func createInterceptor(for authorisation: Authorisation) -> RequestInterceptor {
        switch authorisation {
        case .basic:
            return basicAuthentication

        case .bearer:
            return bearerAuthentication

        case let .login(username, password):
            return PasswordAuthentication(username: username, password: password)
        }
    }
}

struct PasswordAuthentication: RequestInterceptor {

    // MARK: - Properties

    private let username: String
    private let password: String

    // MARK: - Lifecycle

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // MARK: - Public methods

    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(username: username, password: password))
        completion(.success(urlRequest))
    }
}

struct BasicAuthentication: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization("Basic dXNlcm5hbWU6c2VjcmV0"))
        completion(.success(urlRequest))
    }
}

struct BearerAuthentication: RequestInterceptor {

    // MARK: - Properties

    private let userCrenetialsStorage: UserCredentialsStoraging

    // MARK: - Lifecycle

    init(userCrenetialsStorage: UserCredentialsStoraging) {
        self.userCrenetialsStorage = userCrenetialsStorage
    }

    // MARK: - Public methods

    func adapt(_ urlRequest: URLRequest, using state: RequestAdapterState, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let token = userCrenetialsStorage.getAccessKey() else {
            completion(.success(urlRequest))
            return
        }

        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: token))
        completion(.success(urlRequest))
    }
}
