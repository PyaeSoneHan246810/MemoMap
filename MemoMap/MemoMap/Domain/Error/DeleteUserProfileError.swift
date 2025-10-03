//
//  DeleteUserProfileError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum DeleteUserProfileError: Error {
    case userNotFound
    case deleteFailed
    case unknownError
}
