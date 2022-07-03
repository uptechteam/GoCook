//
//  ColorConfig.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public enum ColorConfig: Equatable {
    case error
    case primary
    case secondary
    case white

    public var main: UIColor {
        switch self {
        case .error:
            return .errorMain

        case .primary:
            return .primaryMain

        case .secondary:
            return .secondaryMain

        case .white:
            return .appWhite
        }
    }

    public var secondary: UIColor {
        switch self {
        case .error:
            return .errorPressed

        case .primary:
            return .primaryPressed

        case .secondary:
            return .secondaryPressed

        case .white:
            return .appWhite
        }
    }
}
