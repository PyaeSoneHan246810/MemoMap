//
//  UsernameError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum UsernameAvailabilityError: Error {
    case taken
    case failedToCheck
    case unknownError
}
