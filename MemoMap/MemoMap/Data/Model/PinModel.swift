//
//  PinModel.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct PinModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId
        case name
        case description
        case photoUrl
        case location
        case createdAt
    }
    let id: String
    let ownerId: String
    let name: String
    let description: String?
    let photoUrl: String?
    let location: GeoPoint
    let createdAt: Date
}

extension PinModel {
    var firestoreDocumentData: [String: Any] {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.ownerId.rawValue: ownerId,
            Self.CodingKeys.name.rawValue: name,
            Self.CodingKeys.description.rawValue: description as Any,
            Self.CodingKeys.photoUrl.rawValue: photoUrl as Any,
            Self.CodingKeys.location.rawValue: location,
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt)
        ]
    }
}
