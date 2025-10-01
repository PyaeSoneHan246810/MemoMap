//
//  DeleteUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum DeleteUserError: Error {
    case userNotFound
    case deleteFailed
    case unknownError
}
