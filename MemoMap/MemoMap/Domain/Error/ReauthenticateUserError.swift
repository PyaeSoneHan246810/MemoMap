//
//  ReauthenticateUserError.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum ReauthenticateUserError: Error, LocalizedError {
    case userNotFound
    case userEmailNotFound
    case invalidCredential
    case wrongPassword
    case userMismatch
    case userDisabled
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .userEmailNotFound:
            "We couldn’t find your email address. Please sign in again."
        case .invalidCredential:
            "Your credentials are invalid. Please try again."
        case .wrongPassword:
            "Your current password is invalid. Please try again."
        case .userMismatch:
            "The credentials don’t match the current user. Please sign in again."
        case .userDisabled:
            "Your account has been disabled. Please contact support for help."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
