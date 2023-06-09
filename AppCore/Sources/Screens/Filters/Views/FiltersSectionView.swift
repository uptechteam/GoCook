//
//  FiltersSectionView.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import Library
import UIKit

final class FiltersSectionView: UIView {

    struct Props: Equatable {
        let title: String
        let optionViewsProps: [FiltersOptionView.Props]
    }

    // MARK: - Properties

    private let titleLabel = UILabel()
    private let optionsStackView = UIStackView()
    // callbacks
    var onTapOption: (Int) -> Void = { _ in }

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
        setupOptionsStackView()
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, optionsStackView])
        stackView.axis = .vertical
        stackView.spacing = 24
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupOptionsStackView() {
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 20
    }

    // MARK: - Public methods

    func render(props: Props) {
        titleLabel.render(title: props.title, color: .textMain, typography: .subtitle)
        renderOptions(viewsProps: props.optionViewsProps)
    }

    // MARK: - Private methods

    private func renderOptions(viewsProps: [FiltersOptionView.Props]) {
        let optionViews = optionsStackView.arrangedSubviews.compactMap { $0 as? FiltersOptionView }
        if optionViews.count != viewsProps.count {
            optionsStackView.subviews.forEach { $0.removeFromSuperview() }
            let views = viewsProps.enumerated().map(makeOptionView)
            views.forEach(optionsStackView.addArrangedSubview)
        } else {
            zip(optionViews, viewsProps).forEach { view, props in view.render(props: props) }
        }
    }

    private func makeOptionView(index: Int, props: FiltersOptionView.Props) -> UIView {
        let optionView = FiltersOptionView()
        optionView.render(props: props)
        optionView.addAction(UIAction(handler: { [unowned self] _ in onTapOption(index) }), for: .touchUpInside)
        return optionView
    }
}
