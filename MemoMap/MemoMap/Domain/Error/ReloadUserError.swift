//
//  ReloadUserError.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation

enum ReloadUserError: Error {
    case userNotFound
    case networkError
    case reloadFailed
    case unknownError
}
