//
//  RegularCell.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 04.06.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import AppViewUtilits
import UIKit

public class RegularCell: AppViewTableCell<RegularCellModel> {
    
    private(set) lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("", for: .normal)
        return btn
    }()
    
    public override func updateView() {
        
        guard let cellModel = cellModel else {
            return
        }
        
        var content: UIListContentConfiguration = {
            switch cellModel.type {
            case .default:
                switch cellModel.style {
                case .default:
                    return self.defaultContentConfiguration()
                case .value1, .value2:
                    return .valueCell()
                case .subtitle:
                    return .valueCell()
                @unknown default:
                    return .valueCell()
                }
            case .selectValue, .checkmark:
                return .valueCell()
            default:
                return self.defaultContentConfiguration()
            }
        }()
        
        content.image = cellModel.icon
        content.imageProperties.reservedLayoutSize = CGSize(width: 29, height: 29)
        content.imageToTextPadding = 12
        content.directionalLayoutMargins = NSDirectionalEdgeInsets(top: cellModel.type == .textContent ? 16 : 0, leading: 0, bottom: cellModel.type == .textContent ? 16 : 0, trailing: 8)
        self.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        content.text = cellModel.title
        content.secondaryText = cellModel.subtitle
        
        switch cellModel.type {
        case .dangerTiny, .dangerBold:
            self.selectionStyle = .default
            content.textProperties.color = .systemRed
            if cellModel.icon == nil {
                content.textProperties.alignment = .center
            }
            content.textProperties.font = .systemFont(ofSize: 17.0, weight: cellModel.type == .dangerTiny ? .regular : .semibold)
            self.accessoryType = .none
            self.accessoryView = nil
        case .withSwitch:
            self.selectionStyle = .none
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(cellModel.isEnabled, animated: true)
            switchView.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
            self.accessoryView = switchView
        case .textContent:
            self.selectionStyle = .none
            self.accessoryType = .none
            self.accessoryView = nil
        case .selectValue:
            self.selectionStyle = .none
            let arrowIcon = UIImage(systemName: "chevron.up.chevron.down")?.withRenderingMode(.alwaysTemplate).withTintColor(.secondaryLabel)
            let arrowIconView = UIImageView(image: arrowIcon)
            arrowIconView.frame = CGRect(x: 0, y: 0, width: 10, height: 14)
            self.accessoryView = arrowIconView
        case .checkmark:
            self.accessoryType = cellModel.isEnabled ? .checkmark : .none
            self.accessoryView = nil
        case .datePicker:
            self.selectionStyle = .none
            let datePicker = UIDatePicker()
            datePicker.date = cellModel.date ?? Date()
            datePicker.locale = .current
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            let action = UIAction(handler: { _ in
                self.cellModel?.dateChanged?(datePicker.date)
            })
            datePicker.addAction(action, for: .valueChanged)
            self.accessoryView = datePicker
        case .default:
            self.selectionStyle = .default
            self.accessoryType = cellModel.accessoryType
            self.accessoryView = nil
        }
        
        self.tintColor = .systemBlue
        self.contentConfiguration = content
        self.layoutIfNeeded()
        
        switch cellModel.type {
        case .selectValue:
            addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: contentView.topAnchor),
                button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                button.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: bounds.width / 2),
                button.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
            button.showsMenuAsPrimaryAction = true
            button.menu = cellModel.contextMenu
        default:
            break
        }
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        button.removeFromSuperview()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        // Set margin for remove button
        let leftMargin: CGFloat = 60.0
        
        if self.isEditing && self.contentView.frame.origin.x != 0 {
            var frame = self.contentView.frame
            let diff = leftMargin - frame.origin.x
            frame.origin.x = leftMargin
            frame.size.width -= diff
            self.contentView.frame = frame
        }
    }
    
    override public var canBecomeFirstResponder: Bool {
        true
    }
    
    @objc
    private func toggleSwitch(_ sender: UISwitch) {
        cellModel?.switchChanged?(sender.isOn)
    }
}
