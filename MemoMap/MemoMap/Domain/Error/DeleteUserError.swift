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
            "User Not Found"
        case .requiresRecentLogin:
            "Requires Recent Login"
        case .unknownError:
            "Unknown Error"
        }
    }
}
