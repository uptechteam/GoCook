//
//  Array+Recipe.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

extension Array: EmptyDomainModel {
    public static var empty: [Element] {
        []
    }
}
