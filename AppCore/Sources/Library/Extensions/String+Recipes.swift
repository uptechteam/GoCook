//
//  String+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.07.2022.
//

import UIKit

extension String {
    public static func calculateTextSize(_ text: String, width: CGFloat, typography: Typography) -> CGSize {
        let nsString = NSString(string: text)
        let bounds = nsString.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: typography.getAttributes(color: .clear),
            context: nil
        )
        return .init(width: ceil(bounds.width), height: ceil(bounds.height))
    }

    public static func calculateTextSize(_ text: NSAttributedString, width: CGFloat) -> CGSize {
        let bounds = text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            context: nil
        )
        return .init(width: ceil(bounds.width), height: ceil(bounds.height))
    }
}
