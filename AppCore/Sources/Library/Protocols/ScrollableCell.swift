//
//  ScrollableCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.08.2022.
//

import Foundation

public protocol ScrollableCell: AnyObject {
    var id: Int { get }
    var scrollableOffset: CGFloat { get set }
}
