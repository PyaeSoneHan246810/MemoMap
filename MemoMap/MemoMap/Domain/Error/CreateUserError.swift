//
//  CreateAccountError.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

enum CreateUserError: Error {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case networkError
    case unknownError
}

