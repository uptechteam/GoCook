//
//  NetworkClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Foundation
import Helpers
import Moya

protocol NetworkClient {
    func request(_ target: AppTarget<some Decodable>) async throws -> Response
}

final class NetworkClientImpl: MoyaProvider<TargetEnvelope>, NetworkClient {

    // MARK: - Properties

    private let notificationCenter: NotificationCenter

    // MARK: - Lifecycle

    init(
        bundle: Bundle,
        notificationCenter: NotificationCenter
    ) {
        self.notificationCenter = notificationCenter
        super.init(
            callbackQueue: nil,
            plugins: [
                LoggerPlugin()
            ]
        )

        setupSessionConfiguration()
    }

    // MARK: - Public methods

    func request(_ target: AppTarget<some Decodable>) async throws -> Response {
        return requestPublisher(target.envelope, callbackQueue: nil)
            .compactCatch { [weak self] error in
              self?.handleUnauthorizedRequest(error: error, target: target)
            }
            .compactCatch { [weak self] error in
                self?.tryToCatchCustomErrorDescription(from: error)
            }
            .mapError { $0 as Error }
            .flatMap { [weak self] response -> AnyPublisher<Response, Error> in
                let decoder = JSONDateDecoder()
                do {
                    let decodedResponse = try decoder.decode(Response.self, from: response.data)
                    return Just(decodedResponse)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    self?.logDecodingError(response: response, error: error)
                    return Fail(error: APIError.decoding)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private methods

    private func setupSessionConfiguration() {
        session.sessionConfiguration.timeoutIntervalForRequest = 15
    }

    private func handleUnauthorizedRequest<Response: Decodable>(
        error: MoyaError,
        target: AppTarget<Response>
    ) -> AnyPublisher<Moya.Response, Error> {
        guard let response = error.response, response.statusCode == 401 else {
            return Fail<Moya.Response, Error>(error: error as Error)
                .eraseToAnyPublisher()
        }

        return unauthorizedRequestHandler.refreshToken()
            .compactFlatMap { [weak self] in
                self?.requestPublisher(target.envelope, callbackQueue: nil)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .handleEvents(receiveCompletion: { [notificationCenter] completion in
                switch completion {
                case .failure:
                    let notification = AppNotification.makeNotification(AppNotification(type: .unauthorizedError))
                    notificationCenter.post(notification)

                default:
                    break
                }
            })
            .mapError { _ in error as Error }
            .eraseToAnyPublisher()
    }

    private func tryToCatchCustomErrorDescription(from error: Error) -> AnyPublisher<Moya.Response, Error> {
        let decoder = JSONDateDecoder()
        if let moyaError = error as? MoyaError,
           let response = moyaError.response,
           let customError = try? decoder.decode(ErrorRespose.self, from: response.data) {
            return Fail(error: APIError.general(description: customError.message))
                .eraseToAnyPublisher()
        } else {
            return Fail<Moya.Response, Error>(error: error as Error)
                .eraseToAnyPublisher()
        }
    }

    private func logDecodingError(response: Moya.Response, error: Error) {
        let requestURL = response.request?.url?.absoluteString ?? "No path"
        switch error as? DecodingError {
        case .dataCorrupted(let context):
            let codingPath = "\(context.codingPath.map(\.stringValue).joined(separator: ", "))"
            log.error(
                "Decode error: data corrupted.",
                metadata: ["Coding path": .string(codingPath), "Request": .string("\(requestURL)")]
            )

        case .keyNotFound(let key, _):
            log.error(
                "Decode error, key not found",
                metadata: ["Key": .string("\(key)"), "Request": .string("\(requestURL)")]
            )

        case .typeMismatch(let type, _):
            log.error(
                "Decode error: type mismatch",
                metadata: ["Type": .string("\(type)"), "Request": .string("\(requestURL)")]
            )

        case .valueNotFound(let type, _):
            log.error(
                "Decode error: value not found",
                metadata: ["Description": .string("\(type)"), "Request": .string("\(requestURL)")]
            )

        default:
            log.error("Decode error: unknown", metadata: ["Description": .string(error.localizedDescription)])
        }
    }
}

