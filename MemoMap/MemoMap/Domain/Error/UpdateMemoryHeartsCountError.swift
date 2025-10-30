//
//  UpdateMemoryHeartsCountError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum UpdateMemoryHeartsCountError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update memory hearts count. Please try again later."
        }
    }
}
