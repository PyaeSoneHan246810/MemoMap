//
//  SendPasswordResetError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum SendPasswordResetError: Error, LocalizedError {
    case invalidEmail
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Please enter a valid email address and try again."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
