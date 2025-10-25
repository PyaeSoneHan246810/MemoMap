//
//  SendEmailVerificationError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SendEmailVerificationError: Error, LocalizedError {
    case userNotFound
    case networkError
    case sendFailed
    case unknownError
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Found"
        case .networkError:
            "Network Error"
        case .sendFailed:
            "Send Failed"
        case .unknownError:
            "Unknown Error"
        }
    }
}
