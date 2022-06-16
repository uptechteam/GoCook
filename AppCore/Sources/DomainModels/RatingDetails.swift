//
//  RatingDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

public struct RatingDetails: Equatable {

    // MARK: - Properties

    public let rating: Double
    public let reviewsCount: Int

    // MARK: Lifecycle

    public init(rating: Double, reviewsCount: Int) {
        self.rating = rating
        self.reviewsCount = reviewsCount
    }
}
