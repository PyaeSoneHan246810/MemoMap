//
//  GetMemoryCommentsError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum GetMemoryCommentsError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Failed To Get"
        }
    }
}
