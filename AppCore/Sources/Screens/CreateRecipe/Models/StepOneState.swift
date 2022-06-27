//
//  StepOneState.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import DomainModels
import Foundation
import Helpers

struct StepOneState: Equatable {
    var recipeImageState: RecipeImageState
    var mealName: String
    var categories: Set<CategoryType>
}

enum RecipeImageState: Equatable {

    // MARK: - Properties

    case empty
    case uploading(ImageSource)
    case uploaded(ImageSource, imageID: String)

    var isUploading: Bool {
        switch self {
        case .uploading:
            return true

        default:
            return false
        }
    }

    var uploadedImageSource: ImageSource? {
        switch self {
        case .uploaded(let imageSource, _):
            return imageSource

        default:
            return nil
        }
    }

    // MARK: - Public methods

    mutating func upload(with id: String) {
        switch self {
        case .uploading(let imageSource):
            self = .uploaded(imageSource, imageID: id)

        default:
            self = .empty
        }
    }
}
