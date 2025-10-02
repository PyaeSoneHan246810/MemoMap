//
//  SendPasswordResetError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum SendPasswordResetError: Error {
    case invalidEmail
    case networkError
    case sendFailed
    case unknownError
}
