//
//  GetPinMemoriesError.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import Foundation

enum GetPinMemoriesError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Failed To Get"
        }
    }
}
