//
//  FeedProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import Foundation

extension FeedViewController {
    static func makeProps(from state: State) -> FeedView.Props {
        .init(items: makeItems(state: state))
    }

    private static func makeItems(state: State) -> [RecipeCategoryCell.Props] {
        return [
            .init(title: "Tranding", items: [
                .init(id: "1", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8"))
            ]),
            .init(title: "Breakfast", items: [
                .init(id: "21", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "22", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8"))
            ]),
            .init(title: "Lunch", items: [
                .init(id: "31", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "32", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "33", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8"))
            ]),
            .init(title: "Dinner", items: [
                .init(id: "41", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "42", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "43", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8")),
                .init(id: "44", recipeImage: nil, isLiked: false, name: "Green Hummus with sizzled dolmades", ratingViewProps: RatingView.Props(ratingText: "4.8"))
            ])
        ]
    }
}
