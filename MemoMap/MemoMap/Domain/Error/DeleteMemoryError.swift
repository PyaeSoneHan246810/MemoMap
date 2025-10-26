//
//  DeleteMemoryError.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import Foundation

enum DeleteMemoryError: Error, LocalizedError {
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .deleteFailed:
            "Delete Failed"
        }
    }
}
