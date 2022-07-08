//
//  BasicAuthentication.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Alamofire
import Foundation

struct BasicAuthentication: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        using state: RequestAdapterState,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization("Basic dXNlcm5hbWU6c2VjcmV0"))
        completion(.success(urlRequest))
    }
}
