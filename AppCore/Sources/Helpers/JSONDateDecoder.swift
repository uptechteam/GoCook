//
//  JSONDateDecoder.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Foundation

public final class JSONDateDecoder: JSONDecoder {
    public override init() {
        super.init()
        dateDecodingStrategy = .formatted(DateFormatters.fullDateFormatter)
    }
}
