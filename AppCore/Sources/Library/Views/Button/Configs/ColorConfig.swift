//
//  ColorConfig.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import UIKit

public struct ColorConfig: Equatable {

    // MARK: - Properties

    let main: UIColor
    let secondary: UIColor

    // MARK: - Lifecycle

    public init(main: UIColor, secondary: UIColor) {
        self.main = main
        self.secondary = secondary
    }
}
