//
//  RecipeImageState.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Helpers

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

