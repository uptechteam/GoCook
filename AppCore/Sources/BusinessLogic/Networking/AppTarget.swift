//
//  AppTarget.swift
//  
//
//  Created by Oleksii Andriushchenko on 17.06.2022.
//

import Foundation
import Moya

struct TargetEnvelope: TargetType, AccessTokenAuthorizable {
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let task: Moya.Task
    let headers: [String: String]?
    let sampleData: Data
    let validationType: Moya.ValidationType
    let authorizationType: AuthorizationType?
}

struct AppTarget<Response: Decodable> {
    let envelope: TargetEnvelope
}
