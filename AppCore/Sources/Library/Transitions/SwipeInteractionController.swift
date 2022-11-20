//
//  SwipeInteractionController.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import UIKit

public final class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    // MARK: - Proeprties

    public var isInteractionInProgress = false
    private weak var viewController: UIViewController?

    // MARK: - Lifecycle

    public init(viewController: UIViewController) {
        super.init()
        prepareGestureRecognizer(in: viewController.view)
        self.viewController = viewController
    }

    // MARK: - Private methods

    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture))
        gesture.edges = .left
        view.addGestureRecognizer(gesture)
    }

    @objc
    private func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let view = gestureRecognizer.view else {
            isInteractionInProgress = false
            cancel()
            return
        }

        let translation = gestureRecognizer.translation(in: view)
        var progress = (translation.x / view.frame.width)
        progress = min(max(progress, 0.0), 1.0)
        progress = adjustPercentage(value: progress)

        switch gestureRecognizer.state {
        case .began:
            isInteractionInProgress = true
            viewController?.navigationController?.popViewController(animated: true)

        case .changed:
            update(progress)

        case .cancelled:
            isInteractionInProgress = false
            cancel()

        case .ended:
            isInteractionInProgress = false
            if percentComplete > 0.5 {
                finish()
            } else {
                cancel()
            }

        default:
            break
        }
    }

    /// Slightly adjust percentage value to synchronize gesure movement with screen animation.
    private func adjustPercentage(value: CGFloat) -> CGFloat {
        (value - 0.5) * 0.7 + 0.5
    }
}
