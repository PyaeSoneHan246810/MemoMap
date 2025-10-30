//
//  GetCountError.swift
//  MemoMap
//
//  Created by Dylan on 14/10/25.
//

import Foundation

enum GetCountError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to get the count. Please try again later."
        }
    }
}
