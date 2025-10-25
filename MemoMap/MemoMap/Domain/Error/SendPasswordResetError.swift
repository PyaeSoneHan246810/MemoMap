//
//  SendPasswordResetError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum SendPasswordResetError: Error, LocalizedError {
    case invalidEmail
    case networkError
    case sendFailed
    case unknownError
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "Invalid Email"
        case .networkError:
            "Network Error"
        case .sendFailed:
            "Send Failed"
        case .unknownError:
            "Unknown Error"
        }
    }
}
