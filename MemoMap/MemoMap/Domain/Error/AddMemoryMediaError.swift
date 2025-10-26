//
//  AddMemoryMediaError.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

enum AddMemoryMediaError: Error, LocalizedError {
    case mediaNotExist
    case addFailed
    var errorDescription: String? {
        switch self {
        case .mediaNotExist:
            "Media Not Exist"
        case .addFailed:
            "Add Failed"
        }
    }
}
