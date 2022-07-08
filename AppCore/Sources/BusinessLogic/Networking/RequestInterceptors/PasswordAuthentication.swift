//
//  PasswordAuthentication.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Alamofire
import Foundation

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

    func adapt(
        _ urlRequest: URLRequest,
        using state: RequestAdapterState,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(username: username, password: password))
        completion(.success(urlRequest))
    }
}
