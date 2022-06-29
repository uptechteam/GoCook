//
//  InputEnvelope.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

import DomainModels

public struct InputEnvelope: Equatable {

    // MARK: - Properties

    public let details: InputDetails

    // MARK: - Lifecycle

    public init(details: InputDetails) {
        self.details = details
    }
}
