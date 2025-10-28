//
//  UpdatePasswordError.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum UpdatePasswordError: Error, LocalizedError {
    case userNotFound
    case operationNotAllowed
    case requiresRecentLogin
    case weakPassword
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .operationNotAllowed:
            "Password update is not allowed. Please contact support for help."
        case .requiresRecentLogin:
            "For security reasons, please sign in again before changing your password."
        case .weakPassword:
            "Your password is weak. Try using a stronger password."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
