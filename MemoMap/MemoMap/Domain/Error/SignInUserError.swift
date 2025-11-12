//
//  SignInUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SignInUserError: Error, LocalizedError {
    case invalidEmail
    case invalidCredential
    case userDisabled
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Please enter a valid email address and try again."
        case .invalidCredential:
            "The email or password you entered doesn’t match. Please try again."
        case .userDisabled:
            "Your account has been disabled. Please contact support for help."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
