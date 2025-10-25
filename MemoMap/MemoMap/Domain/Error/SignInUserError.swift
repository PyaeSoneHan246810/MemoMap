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
    case wrongPassword
    case userDisabled
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Invalid Email"
        case .invalidCredential:
            "Invalid Credential"
        case .wrongPassword:
            "Wrong Password"
        case .userDisabled:
            "User Disabled"
        case .networkError:
            "Network Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}
