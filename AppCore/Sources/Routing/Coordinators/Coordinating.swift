//
//  Coordinating.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

protocol Coordinating {
    var rootViewController: UIViewController { get }

    func start()
}
