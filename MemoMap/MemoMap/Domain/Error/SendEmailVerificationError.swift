//
//  SendEmailVerificationError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SendEmailVerificationError: Error, LocalizedError {
    case userNotFound
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
