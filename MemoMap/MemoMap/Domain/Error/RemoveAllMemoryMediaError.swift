//
//  RemoveAllMemoryMediaError.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

enum RemoveAllMemoryMediaError: Error, LocalizedError {
    case removeFailed
    var errorDescription: String? {
        switch self {
        case .removeFailed:
            "Remove Failed"
        }
    }
}
