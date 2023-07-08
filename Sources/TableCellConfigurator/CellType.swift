//
//  CellType.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 04.06.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation

public enum CellType: CaseIterable {
    case `default`, dangerTiny, dangerBold, withSwitch, textContent, selectValue, checkmark, datePicker
    
    public var isAllowLink: Bool {
        switch self {
        case .default, .dangerTiny, .dangerBold, .selectValue, .checkmark:
            return true
        case .withSwitch, .datePicker, .textContent:
            return false
        }
    }
}
