//
//  SignInUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SignInUserError: Error {
    case invalidEmail
    case invalidCredential
    case wrongPassword
    case userDisabled
    case networkError
    case signInFailed
    case unknownError
}
