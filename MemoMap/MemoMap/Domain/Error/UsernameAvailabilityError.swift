//
//  UsernameAvailabilityError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum UsernameAvailabilityError: Error, LocalizedError {
    case taken
    case checkFailed
    var errorDescription: String? {
        switch self {
        case .taken:
            "Taken"
        case .checkFailed:
            "Check Failed"
        }
    }
}
