//
//  AddCommentError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum AddMemoryCommentError: Error, LocalizedError {
    case addFailed
    var errorDescription: String? {
        switch self {
        case .addFailed:
            "Unable to add your comment. Please try again later."
        }
    }
}
