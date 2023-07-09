//
//  InputCellModel.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 09.07.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import AppViewUtilits
import UIKit

public class InputCellModel: AppViewCellIdentifiable {
    
    let text: String?
    let placeholder: String
    let isInteractiveEnabled: Bool
    let maxLimit: Int?
    
    public var options = InputCellOptions()

    //Callbacks
    var valueChanged: DataCallback<String?>?
    var valueFinishChanged: DataCallback<String?>?
    
    public init(text: String?, placeholder: String, isInteractiveEnabled: Bool, maxLimit: Int? = nil, valueChanged: DataCallback<String?>? = nil, valueFinishChanged: DataCallback<String?>? = nil) {
        self.text = text
        self.placeholder = placeholder
        self.isInteractiveEnabled = isInteractiveEnabled
        self.maxLimit = maxLimit
        self.valueChanged = valueChanged
        self.valueFinishChanged = valueFinishChanged
    }
}
