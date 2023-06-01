//
//  AuthorEnvelope.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import DomainModels

public struct AuthorEnvelope: Equatable {

    // MARK: - Public properties

    public let author: User

    // MARK: - Lifecycle

    public init(author: User) {
        self.author = author
    }
}
