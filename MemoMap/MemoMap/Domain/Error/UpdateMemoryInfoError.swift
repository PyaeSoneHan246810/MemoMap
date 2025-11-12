//
//  UpdateMemoryInfoError.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import Foundation

enum UpdateMemoryInfoError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update the memory information. Please try again later."
        }
    }
}
