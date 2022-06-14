//
//  CACornerMask+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

extension CACornerMask {
    static let all: CACornerMask = [
        CACornerMask.layerMaxXMaxYCorner,
        CACornerMask.layerMinXMaxYCorner,
        CACornerMask.layerMaxXMinYCorner,
        CACornerMask.layerMinXMinYCorner
    ]
}
