//
//  CategoryCell.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.07.2022.
//

import Helpers
import Library
import UIKit

final class CategoryCell: UICollectionViewCell, ReusableCell {

    struct Props: Hashable {
        let backgroundColorSource: ColorSource
        let title: String
        let titleColorSource: ColorSource

        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
    }

    // MARK: - Properties

    private let titleLabel = UILabel()

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
        setupTitleLabel()
    }

    private func setupContentView() {
        contentView.layer.roundCornersContinuosly(radius: 16)
    }

    private func setupTitleLabel() {
        addSubview(titleLabel, withEdgeInsets: UIEdgeInsets(top: 6, left: 23, bottom: 6, right: 23))
    }

    // MARK: - Public methods

    func render(props: Props) {
        contentView.backgroundColor = props.backgroundColorSource.color
        titleLabel.render(title: props.title, color: props.titleColorSource.color, typography: .description)
    }

    static func calculateSize(for props: Props) -> CGSize {
        let size = String.calculateTextSize(props.title, width: .infinity, typography: .description)
        return CGSize(width: 46 + size.width, height: 32)
    }
}
