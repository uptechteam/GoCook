//
//  UILabel+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

extension UILabel {
    public func render(title: String, color: UIColor, typography: Typography) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = typography.lineHeightMultiple
        attributedText = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: color,
                .font: typography.font,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}
