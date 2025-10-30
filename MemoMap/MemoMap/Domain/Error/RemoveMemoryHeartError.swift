//
//  RemoveMemoryHeartError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum RemoveMemoryHeartError: Error, LocalizedError {
    case removeFailed
    var errorDescription: String? {
        switch self {
        case .removeFailed:
            "Unable to remove your heart. Please try again later."
        }
    }
}
