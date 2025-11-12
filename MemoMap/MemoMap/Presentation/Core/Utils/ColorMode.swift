//
//  ColorMode.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum ColorMode: String, Identifiable, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String {
        rawValue
    }
}
