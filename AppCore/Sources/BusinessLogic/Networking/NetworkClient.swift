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
    func execute<Response: Decodable>(_ request: AppRequest) async throws -> Response
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

    public func execute<Response: Decodable>(_ request: AppRequest) async throws -> Response {
        do {
            let interceptor = createInterceptor(for: request.authorisation)
            let responseData: Data
            do {
                responseData = try await AF.request(request.urlRequest, interceptor: interceptor)
                    .cURLDescription(calling: logger.log)
                    .validate(validate)
                    .serializingData(automaticallyCancelling: true)
                    .value
            } catch {
                throw map(error)
            }

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

    private func map(_ error: Error) -> Error {
        switch error.asAFError {
        case .responseValidationFailed(reason: .customValidationFailed(error: let error)):
            return error

        case .sessionTaskFailed(error: let error):
            if (error as NSError).code == -1004 {
                return APIError.cannotConnectToServer
            } else {
                return error
            }

        default:
            return error
        }
    }

    private func validate(
        _ request: URLRequest?,
        _ response: HTTPURLResponse,
        _ data: Data?
    ) -> Result<Void, Error> {
        guard !(200..<300 ~= response.statusCode) else {
            return .success(())
        }

        guard
            let data = data,
            let errorResponse = try? JSONDateDecoder().decode(ErrorResponse.self, from: data)
        else {
            log.error(
                "Unknown error occured",
                metadata: ["Response": .string(response.description)]
            )
            return .failure(APIError.unknownError)
        }

        return .failure(APIError.server(message: errorResponse.reason))
    }
}
