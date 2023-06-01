//
//  UIView+Recipes.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.06.2022.
//

import UIKit

extension UIView {

    // add subview with given constraints
    public func addSubview(_ otherView: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(otherView)
        otherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }

    /// Insert subview with constraints below another subview
    /// - Parameters:
    ///   - view: view to be inserted
    ///   - belowSubview: the sibling view that will be above the inserted view
    ///   - constraints: constraints to active
    public func insertSubview(_ view: UIView, belowSubview siblingView: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(view, belowSubview: siblingView)
        NSLayoutConstraint.activate(constraints)
    }

    /// Add subview with constraints based on insets
    /// - Parameters:
    ///   - otherView: view to be added
    ///   - insets: insets between view and view to be added
    ///   - isSafeAreaRequired: if true then add constraint to safe area layout guide, default is false
    ///   - isPriorityRequired: if false then trailing and bottom achors have less than requiered priority to avoid breaking constraints
    public func addSubview(
        _ otherView: UIView,
        withEdgeInsets insets: UIEdgeInsets,
        isSafeAreaRequired: Bool = false,
        isPriorityRequired: Bool = true
    ) {
        addSubview(otherView, constraints: [
            otherView.topAnchor.constraint(
                equalTo: isSafeAreaRequired ? safeAreaLayoutGuide.topAnchor : topAnchor,
                constant: insets.top
            ),
            otherView.leadingAnchor.constraint(
                equalTo: isSafeAreaRequired ? safeAreaLayoutGuide.leadingAnchor : leadingAnchor,
                constant: insets.left
            ),
            otherView.trailingAnchor.constraint(
                equalTo: isSafeAreaRequired ? safeAreaLayoutGuide.trailingAnchor : trailingAnchor,
                constant: -insets.right
            )
                .prioritised(as: isPriorityRequired ? .required : .almostRequired),
            otherView.bottomAnchor.constraint(
                equalTo: isSafeAreaRequired ? safeAreaLayoutGuide.bottomAnchor : bottomAnchor,
                constant: -insets.bottom
            )
                .prioritised(as: isPriorityRequired ? .required : .almostRequired)
        ])
    }

    public func insetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> UIView {
        let containerView = UIView()
        containerView.addSubview(self, withEdgeInsets: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
        return containerView
    }

    public func centeredHorizontally() -> UIView {
        let containerView = UIView()
        containerView.addSubview(self, constraints: [
            topAnchor.constraint(equalTo: containerView.topAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        return containerView
    }
}
