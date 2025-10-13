//
//  ListenCountError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum ListenCountError: Error {
    case userNotFound
    case listenFailed
    case failedToGetDocuments
}
