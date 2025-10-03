//
//  ReauthenticateUserError.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum ReauthenticateUserError: Error {
    case userNotFound
    case userEmailNotFound
    case invalidCredential
    case invalidEmail
    case wrongPassword
    case userMismatch
    case userDisabled
    case networkError
    case reauthenticationFailed
    case unknownError
}
