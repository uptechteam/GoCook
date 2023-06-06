//
//  UILabel+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

extension UILabel {
    public func render(title: String, color: UIColor, typography: Typography) {
        attributedText = NSAttributedString(
            string: title,
            attributes: typography.getAttributes(color: color, textAlignment: textAlignment)
        )
    }
}
