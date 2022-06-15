//
//  FontFamily.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

public struct FontConvertible {
    let name: String

    public func font(size: CGFloat) -> UIFont {
        UIFont(name: name, size: size)!
    }
}

public enum FontFamily {
    public enum RedHatDisplay {
        public static let bold = FontConvertible(name: "RedHatDisplay-Bold")
        public static let medium = FontConvertible(name: "RedHatDisplay-Medium")
        public static let regular = FontConvertible(name: "RedHatDisplay-Regular")
    }

    public enum RedHatText {
        public static let medium = FontConvertible(name: "RedHatText-Medium")
    }

    public static func registerFonts() {
        [RedHatDisplay.bold, RedHatDisplay.medium, RedHatDisplay.regular, RedHatText.medium]
            .map(\.name)
            .compactMap { Bundle.module.url(forResource: $0, withExtension: "otf") }
            .map { $0 as CFURL }
            .compactMap(CGDataProvider.init(url:))
            .compactMap(CGFont.init)
            .forEach { CTFontManagerRegisterGraphicsFont($0, nil) }
    }
}
