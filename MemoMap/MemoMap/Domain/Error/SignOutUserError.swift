//
//  SignOutUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SignOutUserError: Error {
    case keychainError
    case signOutFailed
    case unknownError
}
