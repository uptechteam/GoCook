//
//  KeyboardManager.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import Combine
import UIKit

public protocol KeyboardManaging {
    var change: AnyPublisher<KeyboardManager.Change, Never> { get }
}

public final class KeyboardManager: KeyboardManaging {

    public struct Change {
        public let frame: CGRect
        public let duration: TimeInterval
        public let options: UIView.AnimationOptions
        public let notificationName: Notification.Name
    }

    // MARK: - Properties

    private let changeSubject = PassthroughSubject<Change, Never>()
    public var change: AnyPublisher<Change, Never> { changeSubject.eraseToAnyPublisher() }

    // MARK: - Lifecycle

    public init(notificationCenter: NotificationCenter) {
        notificationCenter.addObserver(
            self,
            selector: #selector(change(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        notificationCenter.addObserver(
            self,
            selector: #selector(change(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // MARK: - Private methods

    @objc
    private func change(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curveNumber = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber,
            let curve = UIView.AnimationCurve(rawValue: curveNumber.intValue)
        else {
            return
        }

        let change = Change(
            frame: frame.cgRectValue,
            duration: duration.doubleValue,
            options: UIView.AnimationOptions(rawValue: UInt(curve.rawValue)),
            notificationName: notification.name
        )
        self.changeSubject.send(change)
    }
}
