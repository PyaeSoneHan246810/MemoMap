//
//  CommentData.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

struct CommentData {
    let id: String
    let comment: String
    let userId: String
    let createdAt: Date
}

extension CommentData {
    static let preview1: CommentData = CommentData(
        id: "1",
        comment: "Wow, its a very beautiful place",
        userId: "1", createdAt: .now
    )
}
