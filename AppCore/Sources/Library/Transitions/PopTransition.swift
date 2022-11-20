//
//  PopTransition.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Helpers
import UIKit

public final class PopTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties

    public let fromViewController: UIViewController

    // MARK: - Lifecycle

    public init(fromViewController: UIViewController) {
        self.fromViewController = fromViewController
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

        let frame = transitionContext.containerView.frame
        let width = frame.size.width
        transitionContext.containerView.addSubview(toVC.view)
        transitionContext.containerView.bringSubviewToFront(fromVC.view)
        toVC.view.frame = frame.offsetBy(dx: -width / 3, dy: 0)
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                fromVC.view.frame = frame.offsetBy(dx: width, dy: 0)
                toVC.view.frame = frame
            },
            completion: { _ in
                fromVC.view.frame = frame
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                toVC.view.subviews
                    .filter { $0.tag == 99 }
                    .forEach { $0.removeFromSuperview() }
            }
        )
    }
}
