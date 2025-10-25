//
//  CreateAccountError.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

enum CreateUserError: Error, LocalizedError {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Invalid Email"
        case .weakPassword:
            "Weak Password"
        case .emailAlreadyInUse:
            "Email Already In Use"
        case .networkError:
            "Network Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}

