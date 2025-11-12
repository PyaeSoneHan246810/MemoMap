//
//  DeleteUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum DeleteUserError: Error, LocalizedError {
    case userNotFound
    case requiresRecentLogin
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .requiresRecentLogin:
            "For security reasons, please sign in again before deleting your account."
        case .unknownError:
            "Something went wrong. Please try again later."
        }
    }
}
