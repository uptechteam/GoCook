//
//  UIImage+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 25.06.2022.
//

import Helpers
import UIKit

public extension UIImage {

    // MARK: - Public methods

    /// Create new image with specified limited size.
    /// - Parameter sizeLimit: limit of number of bytes in image.
    /// - Returns: Resized image or nil in case of failure.
    func resizeImage(sizeLimit: Int) -> UIImage? {
        guard let byteCount = pngData()?.count else {
            return nil
        }

        guard byteCount > sizeLimit else {
            return self
        }

        let sideRatioSquared = (Constants.magicNumber * Double(sizeLimit)) / Double(byteCount)
        let sideRatio = sqrt(sideRatioSquared)
        let newSize = CGSize(width: size.width * sideRatio, height: size.height * sideRatio)
        let generatedImage = generateImage(size: newSize)
//        log.info(
//            "Generate new image",
//            metadata: ["Size in KB": .string("\((generatedImage?.pngData()?.count ?? 0) / 1024)")]
//        )
        print("Size in KB: \((generatedImage?.pngData()?.count ?? 0) / 1024)")
        return generatedImage
    }

    // MARK: - Private methods

    private func generateImage(size: CGSize) -> UIImage? {
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: size)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Constants

extension UIImage {
    private enum Constants {
        static let magicNumber = 0.6
    }
}
