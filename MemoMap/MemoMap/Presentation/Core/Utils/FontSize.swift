//
//  FontSize.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI

enum FontSize: String, Identifiable, CaseIterable {
    case smallerFontSize = "Smaller"
    case defaultFontSize = "Default"
    case largerFontSize = "Larger"
    var id: String {
        rawValue
    }
    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .smallerFontSize:
            .medium
        case .defaultFontSize:
            .large
        case .largerFontSize:
            .xLarge
        }
    }
}
