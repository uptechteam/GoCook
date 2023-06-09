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
        let categorySectionViewProps: FiltersSectionView.Props
        let cookingTimeSectionViewProps: FiltersSectionView.Props
        let isApplyButtonVisible: Bool
    }

    // MARK: - Properties

    private let topLineView = UIView()
    let categorySectionView = FiltersSectionView()
    private let dividerView = UIView()
    let cookingTimeSectionView = FiltersSectionView()
    private let applyButton = Button(config: ButtonConfig(buttonSize: .medium))
    // callbacks
    var onTapApply: () -> Void = { }

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
        setupStackView()
        setupTopLineView()
        setupDividerView()
        setupApplyButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupStackView() {
        let stackView = UIStackView(
            arrangedSubviews: [categorySectionView, dividerView, cookingTimeSectionView, UIView(), applyButton]
        )
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 24
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 24, left: 0, bottom: 8, right: 0),
            isSafeAreaRequired: true
        )
        NSLayoutConstraint.activate([
            categorySectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * 24),
            dividerView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            cookingTimeSectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * 24),
            applyButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -2 * 24)
        ])
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

    private func setupDividerView() {
        dividerView.backgroundColor = .gray100
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    private func setupApplyButton() {
        applyButton.addAction(UIAction(handler: { [unowned self] _ in onTapApply() }), for: .touchUpInside)
        applyButton.setTitle(.filtersApply)
    }

    // MARK: - Public methods

    func render(props: Props) {
        categorySectionView.render(props: props.categorySectionViewProps)
        cookingTimeSectionView.render(props: props.cookingTimeSectionViewProps)
        applyButton.isHidden = !props.isApplyButtonVisible
    }
}
