//
//  GetMemoryError.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import Foundation

enum GetMemoryError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load the memory. Please try again later."
        }
    }
}
