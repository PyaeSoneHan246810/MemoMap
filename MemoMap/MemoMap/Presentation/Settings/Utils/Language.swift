//
//  Language.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum Language: String, Identifiable, CaseIterable {
    case english = "English"
    case burmese = "Burmese"
    var id: String {
        rawValue
    }
    var identifier: String {
        switch self {
        case .english:
            "en"
        case .burmese:
            "my"
        }
    }
}
