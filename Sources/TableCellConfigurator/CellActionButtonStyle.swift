//
//  CellActionButtonStyle.swift
//  TableCellConfigurator-iOS
//
//  Created by Pavel Moslienko on 08.07.2023.
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import Foundation
import UIKit

public enum CellActionButtonStyle {
    case accent
    case danger
    case custom(color: UIColor, textAlignment: UIListContentConfiguration.TextProperties.TextAlignment, font: UIFont)
    
    func applyStyle(for textProperties: inout UIListContentConfiguration.TextProperties) {
        switch self {
        case .accent:
            textProperties.color = .systemBlue
            textProperties.alignment = .center
            textProperties.font = .systemFont(ofSize: 17.0, weight: .regular)
        case .danger:
            textProperties.color = .systemRed
            textProperties.alignment = .center
            textProperties.font = .systemFont(ofSize: 17.0, weight: .semibold)
        case let .custom(color, textAlignment, font):
            textProperties.color = color
            textProperties.alignment = textAlignment
            textProperties.font = font
        }
    }
}
