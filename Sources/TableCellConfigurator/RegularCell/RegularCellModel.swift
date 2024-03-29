//
//  RegularCellModel.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 04.06.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import AppViewUtilits
import UIKit

public class RegularCellModel: AppViewCellIdentifiable {
    
    let title: String
    let subtitle: String?
    let icon: UIImage?
    public let type: CellType
    var style: UITableViewCell.CellStyle
    var actionButtonStyle: CellActionButtonStyle?
    var accessoryType: UITableViewCell.AccessoryType
    public var isOn: Bool //Switcher
    public var isInteractiveEnabled: Bool //Allow tap
    public var action: Callback?
    public var contextMenu: UIMenu?
    var date: Date?
    
    public var options = RegularCellOptions()
    
    //Callbacks
    var switchChanged: DataCallback<Bool>?
    var dateChanged: DataCallback<Date>?
    
    public init(title: String, subtitle: String? = nil, icon: UIImage? = nil, type: CellType, style: UITableViewCell.CellStyle = .default, actionButtonStyle: CellActionButtonStyle? = nil, accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator, isOn: Bool = true, isInteractiveEnabled: Bool = true, action: Callback? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.type = type
        self.style = style
        self.actionButtonStyle = actionButtonStyle
        self.accessoryType = accessoryType
        self.isOn = isOn
        self.isInteractiveEnabled = isInteractiveEnabled
        self.action = action
    }
}
// MARK: - Create
public extension RegularCellModel {
    
    static func createDatePicker(title: String, date: Date?, onChange: DataCallback<Date>?) -> RegularCellModel {
        let model = RegularCellModel(
            title: title,
            subtitle: nil,
            icon: nil,
            type: .datePicker,
            style: .default,
            accessoryType: .none,
            action: nil
        )
        model.date = date
        model.dateChanged = onChange
        return model
    }
    
    static func createSwitch(title: String, icon: UIImage? = nil, isOn: Bool, onChange: DataCallback<Bool>?
    ) -> RegularCellModel {
        let model = RegularCellModel(
            title: title,
            subtitle: nil,
            icon: icon,
            type: .withSwitch,
            style: .default,
            accessoryType: .none,
            isOn: isOn
        ) {}
        model.switchChanged = onChange
        return model
    }
    
    static func createDefault(title: String, subtitle: String?, icon: UIImage?, style: UITableViewCell.CellStyle, accessoryType: UITableViewCell.AccessoryType, action: Callback?) -> RegularCellModel {
        RegularCellModel(
            title: title,
            subtitle: subtitle,
            icon: icon,
            type: .default,
            style: style,
            accessoryType: accessoryType,
            action: action
        )
    }
    
    static func createActionButton(title: String, style: CellActionButtonStyle, isInteractiveEnabled: Bool, action: Callback?) -> RegularCellModel {
        RegularCellModel(
            title: title,
            subtitle: nil,
            icon: nil,
            type: .actionButton,
            style: .default,
            actionButtonStyle: style,
            accessoryType: .none,
            isInteractiveEnabled: isInteractiveEnabled,
            action: action
        )
    }
    
    static func createSelectValues(title: String, selectingValue: String?, icon: UIImage?, contextMenu: UIMenu) -> RegularCellModel {
        let model = RegularCellModel(
            title: title,
            subtitle: selectingValue,
            icon: icon,
            type: .selectValue,
            style: .default
        )
        model.contextMenu = contextMenu
        return model
    }
}
