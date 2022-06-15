//
//  ReusableCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    public static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
