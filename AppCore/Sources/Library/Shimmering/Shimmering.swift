//
//  Shimmering.swift
//  
//
//  Created by Oleksii Andriushchenko on 05.06.2023.
//

import UIKit

public protocol Shimmering {
    func update(isAnimating: Bool)
    func updateAnimation()
}

public extension Shimmering where Self: UIView {

    // MARK: - Public methods

    func update(isAnimating: Bool) {
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == Constants.layerKey })
        subviews.forEach { $0.isHidden = isAnimating }
        guard isAnimating else {
            if !isAnimating {
                currentShimmerLayer?.removeFromSuperlayer()
            }

            return
        }

        currentShimmerLayer?.removeFromSuperlayer()
        addShimmeringLayer()
    }

    func updateAnimation() {
        let currentShimmerLayer = layer.sublayers?.first(where: { $0.name == Constants.layerKey })
        guard let currentShimmerLayer else {
            return
        }

        currentShimmerLayer.removeFromSuperlayer()
        addShimmeringLayer()
    }

    // MARK: - Private methods

    private func addShimmeringLayer() {
        let gradientLayer = makeGradientLyer()
        layer.addSublayer(gradientLayer)
        let animation = makeAnimation()
        gradientLayer.add(animation, forKey: animation.keyPath)
    }

    private func makeAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.5, -1.0, -0.5]
        animation.toValue = [1.5, 2.0, 2.5]
        animation.repeatCount = .infinity
        animation.duration = 1.25
        return animation
    }

    private func makeGradientLyer() -> CALayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.backgroundColor = UIColor.secondaryPressed.cgColor
        gradientLayer.cornerRadius = min(bounds.height / 2, 5)
        gradientLayer.frame = getFrame()
        gradientLayer.name = Constants.layerKey
        // location
        let addition = gradientLayer.frame.height == 0 ? 0.1 : 20 / gradientLayer.frame.height
        print()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.3, 0.5, 0.7]
        // colors
        let gradientColorOne = UIColor.disabledBackground.withAlphaComponent(0.5).cgColor
        let gradientColorTwo = UIColor.disabledBackground.withAlphaComponent(0.125).cgColor
        gradientLayer.colors = [gradientColorTwo, gradientColorOne, gradientColorTwo]
        return gradientLayer
    }

    private func getFrame() -> CGRect {
        guard intrinsicContentSize.width > 0 else {
            return bounds
        }

        if let label = self as? UILabel {
            let size = intrinsicContentSize
            switch label.textAlignment {
            case .center:
                return CGRect(origin: CGPoint(x: (bounds.width - size.width) / 2, y: bounds.origin.y), size: size)

            default:
                return CGRect(origin: bounds.origin, size: size)
            }
        } else {
            return CGRect(origin: bounds.origin, size: intrinsicContentSize)
        }
    }
}

// MARK: - Constants

private enum Constants {
    static let layerKey = "layer.shimmering"
}
