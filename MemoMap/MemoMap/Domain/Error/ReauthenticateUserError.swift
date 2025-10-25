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
    case invalidEmail
    case wrongPassword
    case userMismatch
    case userDisabled
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Found"
        case .userEmailNotFound:
            "User Email Not Found"
        case .invalidCredential:
            "Invalid Credential"
        case .invalidEmail:
            "Invalid Email"
        case .wrongPassword:
            "Wrong Password"
        case .userMismatch:
            "User Mismatch"
        case .userDisabled:
            "User Disabled"
        case .networkError:
            "Network Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}
