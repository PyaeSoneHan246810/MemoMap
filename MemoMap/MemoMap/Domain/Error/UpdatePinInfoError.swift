//
//  UpdatePinInfoError.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import Foundation

enum UpdatePinInfoError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update the pin. Please try again later."
        }
    }
}
