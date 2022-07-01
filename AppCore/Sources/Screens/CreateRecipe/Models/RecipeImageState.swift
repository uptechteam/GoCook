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
    case error(message: String)
    case uploading(ImageSource)
    case uploaded(ImageSource, imageID: String)

    var imageID: String? {
        switch self {
        case .uploaded(_, let imageID):
            return imageID

        default:
            return nil
        }
    }

    var errorMessage: String? {
        switch self {
        case .error(let message):
            return message

        default:
            return nil
        }
    }

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

