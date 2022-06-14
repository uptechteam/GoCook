//
//  UILayoutPriority+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

extension UILayoutPriority {
    /// priority used for vertical and horizontal padding, width, height
    /// because initial layout and some animation need constraint for width or height of the view to be 0
    /// and this break some constraints with equal priority
    static var almostRequired: UILayoutPriority {
        return UILayoutPriority(999)
    }
}
