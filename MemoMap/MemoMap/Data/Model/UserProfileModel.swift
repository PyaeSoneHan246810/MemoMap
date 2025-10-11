//
//  UserProfileModel.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseFirestore

struct UserProfileModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case emailAddress
        case username
        case usernameLowercased
        case displayname
        case displaynameLowercased
        case profilePhotoUrl
        case coverPhotoUrl
        case birthday
        case bio
        case createdAt
    }
    let id: String
    let emailAddress: String
    let username: String
    let usernameLowercased: String
    let displayname: String
    let displaynameLowercased: String
    let profilePhotoUrl: String?
    let coverPhotoUrl: String?
    let birthday: Date
    let bio: String
    let createdAt: Date
}

extension UserProfileModel {
    var firestoreDocumentData: [String: Any] {
        [
            Self.CodingKeys.id.rawValue: id,
            Self.CodingKeys.emailAddress.rawValue: emailAddress,
            Self.CodingKeys.username.rawValue: username,
            Self.CodingKeys.usernameLowercased.rawValue: usernameLowercased,
            Self.CodingKeys.displayname.rawValue: displayname,
            Self.CodingKeys.displaynameLowercased.rawValue: displaynameLowercased,
            Self.CodingKeys.profilePhotoUrl.rawValue: profilePhotoUrl as Any,
            Self.CodingKeys.coverPhotoUrl.rawValue: coverPhotoUrl as Any,
            Self.CodingKeys.birthday.rawValue: Timestamp(date: birthday),
            Self.CodingKeys.bio.rawValue: bio,
            Self.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt),
        ]
    }
}
