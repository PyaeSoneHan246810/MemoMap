//
//  UpdateMemoryCommentsCountError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum UpdateMemoryCommentsCountError: Error {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update memory comments count. Please try again later."
        }
    }
}
