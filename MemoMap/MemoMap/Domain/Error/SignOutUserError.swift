//
//  SignOutUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SignOutUserError: Error, LocalizedError {
    case keychainError
    case unknownError
    var errorDescription: String? {
        switch self {
        case .keychainError:
            "Keychain Error"
        case .unknownError:
            "Unknown Error"
        }
    }
}
