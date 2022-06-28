//
//  ErrorView.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import UIKit

public final class ErrorView: UIView {

    public struct Props: Equatable {

        // MARK: - Properties

        public let isVisible: Bool
        public let message: String

        // MARK: - Lifecycle

        public init(isVisible: Bool, message: String) {
            self.isVisible = isVisible
            self.message = message
        }
    }

    // MARK: - Properties

    private let textLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupTextLabel()
    }

    private func setupContentView() {
        backgroundColor = .errorMain
    }

    private func setupTextLabel() {
        textLabel.render(typography: .bodyTwo)
        textLabel.textColor = .appWhite
        addSubview(textLabel, withEdgeInsets: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }

    // MARK: - Public methods

    public func render(props: Props) {
        isHidden = !props.isVisible
        textLabel.text = props.message
    }
}
