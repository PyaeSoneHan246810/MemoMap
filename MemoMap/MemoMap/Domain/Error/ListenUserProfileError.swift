//
//  ListenUserProfileError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum ListenUserProfileError: Error {
    case userNotFound
    case listenFailed
    case documentNotFound
    case getDataFailed
    case unknownError
}
