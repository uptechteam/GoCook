//
//  AppConstants.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import Foundation

public enum AppConstants {
    public enum Time {
        public static let transitionAnimationInterval = 0.33
    }

    public enum Validation {
        public static let nameLengthRange: ClosedRange<Int> = 2...20
    }
}
