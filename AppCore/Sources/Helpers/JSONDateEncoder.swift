//
//  JSONDateEncoder.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Foundation

public final class JSONDateEncoder: JSONEncoder {
    public override init() {
        super.init()
        dateEncodingStrategy = .formatted(DateFormatters.fullDateFormatter)
    }
}
