//
//  CreateAccountError.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

enum CreateUserError: Error, LocalizedError {
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Please enter a valid email address and try again."
        case .emailAlreadyInUse:
            "This email is already in use. Please use a different one."
        case .weakPassword:
            "Your password is weak. Try using a stronger password."
        case .networkError:
            "You’re offline. Check your internet connection and try again."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}

