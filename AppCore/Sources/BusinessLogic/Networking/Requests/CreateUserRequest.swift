//
//  CreateUserRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Foundation

struct CreateUserRequest: Encodable {
    let username: String
    let password: String
}
