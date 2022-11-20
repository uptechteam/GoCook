//
//  PushTransition.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Helpers
import UIKit

public final class PushTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties

    private let snapshot: UIView

    // MARK: - Lifecycle

    public init(snapshot: UIView) {
        self.snapshot = snapshot
        self.snapshot.tag = 99
    }

    // MARK: - Public methods

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        AppConstants.Time.transitionAnimationInterval
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }

        if fromVC.isTabBarVisible, !toVC.isTabBarVisible {
            snapshot.frame.origin = CGPoint(
                x: toVC.view.frame.width / 2 - snapshot.frame.width / 2,
                y: toVC.view.frame.height - fromVC.view.safeAreaInsets.bottom
            )
            fromVC.view.addSubview(snapshot)
        }

        let frame = fromVC.view.frame
        let width = frame.size.width
        transitionContext.containerView.addSubview(toVC.view)
        toVC.view.frame = frame.offsetBy(dx: width, dy: 0)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                fromVC.view.frame = frame.offsetBy(dx: -width / 3, dy: 0)
                toVC.view.frame = frame
            },
            completion: { _ in
                fromVC.view.frame = frame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
