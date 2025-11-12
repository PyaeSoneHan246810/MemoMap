//
//  FollowerModel.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation
import FirebaseFirestore

struct FollowerModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case since
    }
    let id: String
    let since: Date
}

extension FollowerModel {
    var firestoreDocumentData: [String: Any] {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.since.rawValue: Timestamp(date: since)
        ]
    }
}
