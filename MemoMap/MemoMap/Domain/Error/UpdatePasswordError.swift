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
            "User Not Found"
        case .operationNotAllowed:
            "Operation Not Allowed"
        case .requiresRecentLogin:
            "Requires Recent Login"
        case .weakPassword:
            "Weak Password"
        case .networkError:
            "Network Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}
