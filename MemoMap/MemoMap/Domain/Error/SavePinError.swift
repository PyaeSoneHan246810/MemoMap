//
//  SavePinError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum SavePinError: Error {
    case userNotFound
    case saveFailed
    case unknownError
}
