//
//  FiltersView.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Library
import UIKit

final class FiltersView: UIView {

    struct Props: Equatable {
        let categorySection: FiltersSectionView.Props
        let cookingTimeSection: FiltersSectionView.Props
    }

    // MARK: - Properties

    private let topLineView = UIView()
    private let categorySection = FiltersSectionView()
    private let cookingTimeSection = FiltersSectionView()

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
        setupTopLineView()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [categorySection, cookingTimeSection])
    }

    private func setupTopLineView() {
        topLineView.backgroundColor = .divider.withAlphaComponent(0.5)
        addSubview(topLineView, constraints: [
            topLineView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    // MARK: - Public methods

    func render(props: Props) {
        categorySection.render(props: props.categorySection)
        cookingTimeSection.render(props: props.cookingTimeSection)
    }
}
