//
//  BearerAuthentication.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Alamofire
import Foundation

struct BearerAuthentication: RequestInterceptor {

    // MARK: - Properties

    private let userCrenetialsStorage: UserCredentialsStoraging

    // MARK: - Lifecycle

    init(userCrenetialsStorage: UserCredentialsStoraging) {
        self.userCrenetialsStorage = userCrenetialsStorage
    }

    // MARK: - Public methods

    func adapt(
        _ urlRequest: URLRequest,
        using state: RequestAdapterState,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard let token = userCrenetialsStorage.getAccessKey() else {
            completion(.success(urlRequest))
            return
        }

        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: token))
        completion(.success(urlRequest))
    }
}
