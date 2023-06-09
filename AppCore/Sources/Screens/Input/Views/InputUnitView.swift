//
//  InputUnitView.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Library
import UIKit

final class InputUnitView: UIControl {

    struct Props: Equatable {
        let isVisible: Bool
        let text: String
        let units: [String]
    }

    // MARK: - Properties

    private let unitTextField = UITextField()
    private let bottomChevronImageView = UIImageView()
    private let unitPickerView = UIPickerView()
    private var units: [String] = []
    // callbacks
    var onSelectItem: (Int) -> Void = { _ in }

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
        setupUnitTextField()
        setupUnitPickerView()
        setupBottomChevronImageView()
    }

    private func setupContentView() {
        addAction(
            UIAction(handler: { [unitTextField] _ in
                unitTextField.becomeFirstResponder()
            }),
            for: .touchUpInside
        )
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [unitTextField, bottomChevronImageView])
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        addSubview(stackView, withEdgeInsets: .zero)
    }

    private func setupUnitTextField() {
        unitTextField.autocorrectionType = .no
        unitTextField.font = Typography.subtitleThree.font
        unitTextField.inputAccessoryView = nil
        unitTextField.inputView = unitPickerView
        unitTextField.spellCheckingType = .no
        unitTextField.textColor = .textMain
        unitTextField.tintColor = .clear
        NSLayoutConstraint.activate([
            unitTextField.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupUnitPickerView() {
        unitPickerView.dataSource = self
        unitPickerView.delegate = self
    }

    private func setupBottomChevronImageView() {
        bottomChevronImageView.image = .bottomChevron
    }

    // MARK: - Public methods

    func render(props: Props) {
        isHidden = !props.isVisible
        unitTextField.text = props.text
        if units != props.units {
            self.units = props.units
            unitPickerView.reloadAllComponents()
        }
    }
}

// MARK: - Datasource

extension InputUnitView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelectItem(row)
    }
}

extension InputUnitView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        units.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        units[safe: row] ?? "-"
    }
}
