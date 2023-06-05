//
//  RatingView+Props.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import DomainModels

public extension RatingView {
    static func makeProps(recipe: Recipe) -> Props {
        let isActive = recipe.rating > 0
        if isActive {
            return .init(
                isActive: true,
                ratingText: "\(recipe.rating)",
                description: ""
            )
        } else {
            return .init(
                isActive: false,
                ratingText: .libraryRatingViewZero,
                description: .libraryRatingViewNoReviews
            )
        }
    }

    static func makeProps(recipeDetails: RecipeDetails) -> Props {
        let reviewsCount = recipeDetails.ratingDetails.reviewsCount
        if reviewsCount > 0 {
            return .init(
                isActive: true,
                ratingText: "\(recipeDetails.ratingDetails.rating)",
                description: reviewsCount == 1 ? .libraryRatingViewOneReview : .libraryRatingViewReviews(reviewsCount)
            )
        } else {
            return .init(
                isActive: false,
                ratingText: "",
                description: .libraryRatingViewNoReviews
            )
        }
    }
}
