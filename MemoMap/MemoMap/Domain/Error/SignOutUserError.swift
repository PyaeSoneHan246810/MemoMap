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
            "We couldn’t sign you out completely due to a credential issue. Please try again."
        case .unknownError:
            "Something went wrong while signing out. Please try again later."
        }
    }
}
