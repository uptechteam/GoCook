//
//  EmptyDomainModel.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Foundation

public protocol EmptyDomainModel {
    static var empty: Self { get }
}
