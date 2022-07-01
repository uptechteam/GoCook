//
//  Typography.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public enum Typography {
    case headerOne
    case headerTwo
    case subtitle
    case subtitleTwo
    case subtitleThree
    case body
    case bodyTwo
    case description
    case buttonLarge
    case buttonSmall
    case other

    public var font: UIFont {
        switch self {
        case .headerOne, .headerTwo, .subtitle, .subtitleTwo, .description:
            return FontFamily.RedHatDisplay.medium.font(size: fontSize)

        case .subtitleThree, .body, .bodyTwo:
            return FontFamily.RedHatDisplay.regular.font(size: fontSize)

        case .buttonLarge, .buttonSmall:
            return FontFamily.RedHatText.medium.font(size: fontSize)

        case .other:
            return FontFamily.RedHatDisplay.bold.font(size: fontSize)
        }
    }

    public var fontSize: CGFloat {
        switch self {
        case .headerOne:
            return 40

        case .headerTwo:
            return 30

        case .subtitle:
            return 20

        case .subtitleTwo, .subtitleThree:
            return 18

        case .body, .buttonLarge:
            return 16

        case .bodyTwo, .description, .buttonSmall, .other:
            return 14
        }
    }

    public var lineHeightMultiple: CGFloat {
        switch self {
        case .headerOne, .headerTwo, .subtitle:
            return 0.91

        case .subtitleTwo, .subtitleThree:
            return 1.01

        case .body:
            return 0.94

        case .bodyTwo, .description, .buttonSmall, .other:
            return 1.08

        case .buttonLarge:
            return 1.32
        }
    }

    public var parameters: [NSAttributedString.Key: Any] {
        return [
            .font: font
        ]
    }
}
