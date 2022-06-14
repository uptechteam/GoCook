//
//  CALayer+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

extension CALayer {
    // add corner radius to view
    public func roundCornersContinuosly(radius: CGFloat, corners: CACornerMask = .all) {
        maskedCorners = corners
        cornerRadius = radius
        cornerCurve = .continuous
    }

    // add border to view
    public func addBorder(color: UIColor, width: CGFloat) {
        borderColor = color.cgColor
        borderWidth = width
    }

    public func addShadow(
        color: CGColor = UIColor.black.cgColor,
        opacitiy: Float,
        radius: CGFloat,
        offset: CGSize
    ) {
        self.shadowColor = color
        self.shadowOpacity = opacitiy
        self.shadowRadius = radius
        self.shadowOffset = offset
    }
}
