//
//  ErrorPresentable.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Foundation
import UIKit

public protocol ErrorPresentable {
    func show(errorMessage: String)
}

extension ErrorPresentable where Self: UIViewController {
    public func show(errorMessage: String) {
        // Getting parent view
        let controller = navigationController ?? self
        guard let view = controller.view else {
            return
        }

        // Check if an error is currently displayed
        guard !view.subviews.contains(where: { $0 is ErrorView }) else {
            return
        }

        // Creating error view and add to parent
        let errorView = ErrorView()
        errorView.render(props: ErrorView.Props(isVisible: true, message: errorMessage))
        let visibleErrorConstraint = errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        let hiddenErrorConstraint = errorView.bottomAnchor.constraint(equalTo: view.topAnchor)
        view.addSubview(errorView, constraints: [
            hiddenErrorConstraint,
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.layoutIfNeeded()

        // Animate appearance
        UIView.animate(withDuration: Constants.animationDuration) {
            hiddenErrorConstraint.isActive = false
            visibleErrorConstraint.isActive = true
            view.layoutIfNeeded()
        }

        // Animate disappearing
        UIView.animate(withDuration: Constants.animationDuration, delay: Constants.animationDuration + 3) {
            visibleErrorConstraint.isActive = false
            hiddenErrorConstraint.isActive = true
            view.layoutIfNeeded()
        } completion: { _ in
            errorView.removeFromSuperview()
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let animationDuration: TimeInterval = 1
}
