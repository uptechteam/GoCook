//
//  UIView+Shimmering.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import UIKit

public extension UIView {
    func toggle(isShimmering: Bool) {
        if let shimmeringView = self as? Shimmering {
            shimmeringView.update(isAnimating: isShimmering)
        } else {
            subviews.forEach { subview in
                subview.toggle(isShimmering: isShimmering)
            }
        }
    }

    func updateShimmering() {
        if let shimmeringView = self as? Shimmering {
            shimmeringView.updateAnimation()
        } else {
            subviews.forEach { subview in
                subview.updateShimmering()
            }
        }
    }
}
