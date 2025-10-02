//
//  UsernameError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum UsernameError: Error {
    case taken
    case failedToCheck
    case unknown
}
