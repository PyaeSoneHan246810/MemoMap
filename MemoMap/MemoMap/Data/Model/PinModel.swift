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
        case createdAt
        case latitude
        case longitude
    }
    let id: String
    let ownerId: String
    let name: String
    let description: String?
    let photoUrl: String?
    let latitude: Double
    let longitude: Double
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
            "location": GeoPoint(latitude: latitude, longitude: longitude),
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt)
        ]
    }
}
