//
//  SignOutUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SignOutUserError: Error, LocalizedError {
    case keychainError
    case signOutFailed
    case unknownError
    var errorDescription: String? {
        switch self {
        case .keychainError:
            "Keychain Error"
        case .signOutFailed:
            "Sign Out Failed"
        case .unknownError:
            "Unknown Error"
        }
    }
}
