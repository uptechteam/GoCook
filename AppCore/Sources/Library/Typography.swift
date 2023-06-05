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
    // Check if needed
    case headerThree
    case headerFour
    case subtitle
    case subtitleTwo
    case subtitleThree
    // Check if needed
    case subtitleFour
    case body
    case bodyTwo
    // Check if needed
    case bodyThree
    case description
    case buttonLarge
    case buttonSmall
    case other

    // MARK: - Properties

    public var font: UIFont {
        switch self {
        case .headerOne, .headerTwo, .headerFour, .subtitle, .subtitleTwo, .subtitleFour, .description:
            return FontFamily.RedHatDisplay.medium.font(size: fontSize)

        case .headerThree, .subtitleThree, .body, .bodyTwo, .bodyThree:
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

        case .headerTwo, .headerThree:
            return 30

        case .headerFour:
            return 24

        case .subtitle:
            return 20

        case .subtitleTwo, .subtitleThree:
            return 18

        case .subtitleFour, .body, .buttonLarge:
            return 16

        case .bodyTwo, .description, .buttonSmall, .other:
            return 14

        case .bodyThree:
            return 13
        }
    }

    public var lineHeight: CGFloat {
        switch self {
        case .headerOne:
            return 48

        case .headerTwo, .headerThree, .headerFour:
            return 36

        case .buttonLarge:
            return 28

        case .subtitle, .subtitleTwo, .subtitleThree, .subtitleFour:
            return 24

        case .body, .bodyTwo, .bodyThree, .description, .buttonSmall, .other:
            return 20
        }
    }

    // MARK: - Public methods

    public func getAttributes(
        color: UIColor,
        textAlignment: NSTextAlignment = .natural
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = -2
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        return [
            .baselineOffset: (lineHeight - font.lineHeight) / 2,
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle
        ]
    }
}
