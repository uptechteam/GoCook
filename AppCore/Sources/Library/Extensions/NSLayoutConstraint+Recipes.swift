//
//  NSLayoutConstraint+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

extension NSLayoutConstraint {
    func prioritised(as priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
