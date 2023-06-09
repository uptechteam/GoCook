//
//  Coordinating.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

@MainActor
protocol Coordinating: AnyObject {

    // MARK: - Properties

    var rootViewController: UIViewController { get }

    // MARK: - Public methods

    func start()
}
