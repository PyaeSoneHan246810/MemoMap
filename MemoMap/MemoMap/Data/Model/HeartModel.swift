//
//  HeartModel.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import FirebaseFirestore

struct HeartModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
    }
    let id: String
    let createdAt: Date
}

extension HeartModel {
    var firestoreDocumentData: [String: Any] {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt)
        ]
    }
}
