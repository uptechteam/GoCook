//
//  AppTarget.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Alamofire
import Foundation

public struct AppRequest {
    public let urlRequest: URLRequestConvertible
    public let authorisation: Authorisation
}

public enum Authorisation {
    case basic
    case bearer
    case login(username: String, password: String)
}
