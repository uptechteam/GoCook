//
//  BaseNavigationController.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import UIKit

public final class BaseNavigationController: UINavigationController {

    // MARK: - Properties

    public override var childForStatusBarStyle: UIViewController? {
        presentedViewController ?? topViewController
    }

    // MARK: - Lifecycle

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Deinit \(self)")
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationBar.backgroundColor = .clear
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backIndicatorImage = UIImage()
        navigationBar.backIndicatorTransitionMaskImage = UIImage()
    }
}
