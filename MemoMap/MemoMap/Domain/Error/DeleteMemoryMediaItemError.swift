//
//  DeleteMemoryMediaItemError.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

enum DeleteMemoryMediaItemError: Error, LocalizedError {
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .deleteFailed:
            "Unable to delete the memory media item. Please try again later."
        }
    }
}
