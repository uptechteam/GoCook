//
//  File.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

struct StepThreeState: Equatable {

    // MARK: - Properties

    var cookingTime: Int? {
        didSet {
            isCookingTimeValid = false
        }
    }
    var isCookingTimeValid = true
    var instructions: [String] {
        didSet {
            areInstructionsValid = true
        }
    }
    var areInstructionsValid = true

    var isDataValid: Bool {
        isCookingTimeValid && areInstructionsValid
    }

    // MARK: - Public methods

    mutating func validate() {
        isCookingTimeValid = cookingTime.flatMap { $0 > 0} ?? false
        areInstructionsValid = !instructions.isEmpty && instructions.allSatisfy { !$0.isEmpty }
    }
}
