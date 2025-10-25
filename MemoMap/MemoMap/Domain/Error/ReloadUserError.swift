//
//  ReloadUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum ReloadUserError: Error, LocalizedError {
    case userNotFound
    case networkError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Found"
        case .networkError:
            "Network Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}
