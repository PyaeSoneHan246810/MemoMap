//
//  CommentModel.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import FirebaseFirestore

struct CommentModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case userId
        case createdAt
    }
    let id: String
    let comment: String
    let userId: String
    let createdAt: Date
}

extension CommentModel {
    var firestoreDocumentData: [String: Any] {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.comment.rawValue: comment,
            Self.CodingKeys.userId.rawValue: userId,
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt)
        ]
    }
}
