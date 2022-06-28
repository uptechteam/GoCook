//
//  ColorSource.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import UIKit

public enum ColorSource: Equatable {
    case color(UIColor)

    public var color: UIColor {
        switch self {
        case .color(let color):
            return color
        }
    }
}
