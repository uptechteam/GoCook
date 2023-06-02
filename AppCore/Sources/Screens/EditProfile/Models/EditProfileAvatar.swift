//
//  EditProfileAvatar.swift
//  
//
//  Created by Oleksii Andriushchenko on 02.06.2023.
//

import Helpers

enum EditProfileAvatar: Equatable {

    case empty
    case avatar(ImageSource)
    case uploading(ImageSource)
    case uploaded(ImageSource, imageID: String)

    // MARK: - Properties

    var isUploading: Bool {
        switch self {
        case .uploading:
            return true

        default:
            return false
        }
    }

    var image: ImageSource? {
        switch self {
        case .avatar(let avatar), .uploaded(let avatar, _):
            return avatar

        default:
            return nil
        }
    }

    var imageID: String? {
        switch self {
        case .uploaded(_, let imageID):
            return imageID

        default:
            return nil
        }
    }
}
