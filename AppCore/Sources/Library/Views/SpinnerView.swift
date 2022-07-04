//
//  SpinnerView.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import Helpers
import UIKit

public final class SpinnerView: UIView {

    // MARK: - Properties

    private var circleColor: UIColor
    private let closeImageView = UIImageView()
    private var circleLayer: CALayer?
    private var isAnimating = false

    // MARK: - Lifecycle

    public init(circleColor: UIColor = .appWhite) {
        self.circleColor = circleColor
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupCloseImageView()
    }

    private func setupContentView() {
        isHidden = true
    }

    private func setupCloseImageView() {
        closeImageView.isHidden = true
        addSubview(closeImageView, constraints: [
            closeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            closeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Public methods

    public func toggle(isAnimating: Bool) {
        guard self.isAnimating != isAnimating else {
            return
        }

        isHidden = !isAnimating
        closeImageView.isHidden = !isAnimating
        self.isAnimating = isAnimating
        if isAnimating {
            layer.speed = 1
            setUpAnimation(size: bounds.size, color: circleColor)
        } else {
            circleLayer?.removeFromSuperlayer()
            circleLayer = nil
        }
    }

    public func set(imageSource: ImageSource) {
        closeImageView.set(imageSource)
    }

    // MARK: - Private methods

    private func setUpAnimation(size: CGSize, color: UIColor) {
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards

        let circleLayer = getLayerWith(size: size, color: color)
        let frame = CGRect(
            x: (layer.bounds.width - size.width) / 2,
            y: (layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )

        circleLayer.frame = frame
        circleLayer.add(groupAnimation, forKey: "animation")
        layer.addSublayer(circleLayer)
        self.circleLayer = circleLayer
    }

    private func getLayerWith(size: CGSize, color: UIColor) -> CALayer {
        let path = UIBezierPath()
        path.addArc(
            withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
            radius: size.width / 2,
            startAngle: -(.pi / 2),
            endAngle: .pi + .pi / 2,
            clockwise: true
        )

        let layer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.lineWidth = 2
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        return layer
    }
}
