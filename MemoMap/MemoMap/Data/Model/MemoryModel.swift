//
//  MemoryModel.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct MemoryModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case pinId
        case ownerId
        case title
        case description
        case media
        case tags
        case dateTime
        case publicStatus
        case createdAt
    }
    let id: String
    let pinId: String
    let ownerId: String
    let title: String
    let description: String?
    let media: [String]
    let tags: [String]
    let dateTime: Date
    let publicStatus: Bool
    let createdAt: Date
}

extension MemoryModel {
    var firestoreDocumentData: [String: Any]  {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.pinId.rawValue: pinId,
            Self.CodingKeys.ownerId.rawValue: ownerId,
            Self.CodingKeys.title.rawValue: title,
            Self.CodingKeys.description.rawValue: description as Any,
            Self.CodingKeys.media.rawValue: media,
            Self.CodingKeys.tags.rawValue: tags,
            Self.CodingKeys.dateTime.rawValue: Timestamp(date: dateTime),
            Self.CodingKeys.publicStatus.rawValue: publicStatus,
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt)
        ]
    }
}
