//
//  UpdatePasswordError.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation

enum UpdatePasswordError: Error {
    case userNotFound
    case operationNotAllowed
    case requiresRecentLogin
    case weakPassword
    case networkError
    case updateFailed
    case unknownError
}
