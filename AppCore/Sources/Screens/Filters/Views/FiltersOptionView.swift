//
//  FiltersOptionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import Helpers
import Library
import UIKit

final class FiltersOptionView: UIControl {

    struct Props: Equatable {
        let title: String
        let checmarkImage: ImageSource
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let checkmarkImageView = UIImageView()

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
        setupStackView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, UIView(), checkmarkImageView])
        stackView.isUserInteractionEnabled = false
        addSubview(stackView, withEdgeInsets: .zero)
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .textMain, typography: .subtitleThree)
        checkmarkImageView.set(props.checmarkImage)
    }
}
