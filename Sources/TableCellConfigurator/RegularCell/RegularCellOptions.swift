//
//  RegularCellOptions.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 08.07.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

public struct RegularCellOptions {
    public var tintColor: UIColor = .systemBlue
    public var layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    public var iconSize: CGSize = CGSize(width: 29, height: 29)
    public var imageToTextPadding: CGFloat = 12.0
}
