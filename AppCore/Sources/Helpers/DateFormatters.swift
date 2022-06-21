//
//  DateFormatters.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import Foundation

enum DateFormatters {
    /// 2020-10-31T10:20:30.123
    static let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()
}
