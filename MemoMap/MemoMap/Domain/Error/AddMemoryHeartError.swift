//
//  AddMemoryHeartError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum AddMemoryHeartError: Error, LocalizedError {
    case addFailed
    var errorDescription: String? {
        switch self {
        case .addFailed:
            "Unable to add your heart. Please try again later."
        }
    }
}
