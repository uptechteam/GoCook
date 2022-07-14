//
//  ImageSource.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Kingfisher
import UIKit

// MARK: - Image Source

public enum ImageSource: Equatable {
    case asset(UIImage?)
    case remote(url: URL)

    public var image: UIImage? {
        switch self {
        case .asset(let image):
            return image

        case .remote:
            return nil
        }
    }

    public var url: URL? {
        switch self {
        case .asset:
            return nil

        case .remote(let url):
            return url
        }
    }
}

// MARK: - UIImageView + ImageSource

extension UIImageView {
    public func set(
        _ imageSource: ImageSource,
        placeholder: UIImage? = nil,
        resizeTo newSize: CGSize? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        switch imageSource {
        case .asset(let image):
            self.image = image ?? placeholder
            completion?(true)

        case .remote(let url):
            let options = makeOptions(with: newSize)
            kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

    private func makeOptions(with size: CGSize?) -> KingfisherOptionsInfo {
        guard let size = size else {
            return []
        }

        let processor = DownsamplingImageProcessor(size: size)
        return [.processor(processor)]
    }
}
