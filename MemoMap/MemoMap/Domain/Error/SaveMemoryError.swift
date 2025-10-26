//
//  SaveMemoryError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum SaveMemoryError: Error, LocalizedError {
    case userNotFound
    case saveFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Found"
        case .saveFailed:
            "Save Failed"
        }
    }
}
