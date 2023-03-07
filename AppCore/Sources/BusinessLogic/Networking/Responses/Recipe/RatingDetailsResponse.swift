//
//  RatingDetailsResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import DomainModels
import Foundation

struct RatingDetailsResponse: Decodable {
    let rating: Double
    let reviewsCount: Int

    var domainModel: RatingDetails {
        .init(rating: rating, reviewsCount: reviewsCount)
    }
}
