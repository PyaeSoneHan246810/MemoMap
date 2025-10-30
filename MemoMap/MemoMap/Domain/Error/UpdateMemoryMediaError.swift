//
//  UpdateMemoryMediaError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum UpdateMemoryMediaError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update the memory media. Please try again later."
        }
    }
}
