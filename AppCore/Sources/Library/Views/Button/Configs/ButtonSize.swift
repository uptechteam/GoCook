//
//  ButtonSize.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public enum ButtonSize: Equatable {
    case large
    case medium
    case small

    var height: CGFloat {
        switch self {
        case .large:
            return 56

        case .medium:
            return 44

        case .small:
            return 32
        }
    }

    var contentInsets: UIEdgeInsets {
        switch self {
        case .large, .medium:
            return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        case .small:
            return UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        }
    }
}
