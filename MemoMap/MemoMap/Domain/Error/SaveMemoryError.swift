//
//  SaveMemoryError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum SaveMemoryError: Error, LocalizedError {
    case userNotFound
    case pinNotSelected
    case saveFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .pinNotSelected:
            "Please choose a pin location before saving your memory."
        case .saveFailed:
            "Unable to save the memory. Please try again later."
        }
    }
}
