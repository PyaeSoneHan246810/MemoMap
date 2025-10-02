//
//  SendEmailVerificationError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum SendEmailVerificationError: Error {
    case userNotFound
    case networkError
    case sendFailed
    case unknownError
}
