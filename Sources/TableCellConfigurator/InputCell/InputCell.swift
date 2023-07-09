//
//  InputCell.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 09.07.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import AppViewUtilits
import UIKit

public class InputCell: AppViewTableCell<InputCellModel> {
    var configuration: UIListContentConfiguration? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    var textField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    public override func updateView() {
        guard let cellModel = cellModel else {
            return
        }
        textField.text = cellModel.text
        textField.placeholder = cellModel.placeholder
        textField.isUserInteractionEnabled = cellModel.isInteractiveEnabled
        textField.textColor = cellModel.isInteractiveEnabled ? cellModel.options.activeColor : cellModel.options.disabledColor
        textField.tintColor = cellModel.options.tintColor
        textField.delegate = self
        
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellModel.options.layoutMargins.left),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: cellModel.options.layoutMargins.right),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.accessoryType = .none
        self.selectionStyle = .none
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        textField.removeFromSuperview()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public override func updateConfiguration(using state: UICellConfigurationState) {
        let updatedConfiguration = (configuration ?? self.defaultContentConfiguration()).updated(for: state)
        if updatedConfiguration != configuration {
            configuration = updatedConfiguration
        }
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: size.width, height: max(size.height, 44))
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        cellModel?.valueChanged?(textField.text)
    }
}

// MARK: - UITextFieldDelegate
extension InputCell: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let limit = cellModel?.maxLimit else {
            return true
        }
        return textField.isAvailableInput(limit: limit, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        cellModel?.valueFinishChanged?(textField.text)
    }
}
