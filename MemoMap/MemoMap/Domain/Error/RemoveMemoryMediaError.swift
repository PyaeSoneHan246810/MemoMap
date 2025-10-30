//
//  RemoveMemoryMediaError.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

enum RemoveMemoryMediaError: Error, LocalizedError {
    case removeFailed
    var errorDescription: String? {
        switch self {
        case .removeFailed:
            "Unable to remove the memory media. Please try again later."
        }
    }
}
