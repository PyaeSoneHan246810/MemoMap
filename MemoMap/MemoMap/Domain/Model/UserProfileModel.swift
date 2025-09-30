//
//  UserProfileModel.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseCore

struct UserProfileModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case emailAddress
        case username
        case displayname
        case profilePhotoUrl
        case coverPhotoUrl
        case birthday
        case bio
        case createdAt
    }
    let id: String
    let emailAddress: String?
    let username: String
    let displayname: String
    let profilePhotoUrl: String?
    let coverPhotoUrl: String?
    let birthday: Date
    let bio: String
    let createdAt: Date
}

extension UserProfileModel {
    var firestoreDocumentData: [String: Any] {
        [
            UserProfileModel.CodingKeys.id.rawValue: id,
            UserProfileModel.CodingKeys.emailAddress.rawValue: emailAddress as Any,
            UserProfileModel.CodingKeys.username.rawValue: username,
            UserProfileModel.CodingKeys.displayname.rawValue: displayname,
            UserProfileModel.CodingKeys.profilePhotoUrl.rawValue: profilePhotoUrl as Any,
            UserProfileModel.CodingKeys.coverPhotoUrl.rawValue: coverPhotoUrl as Any,
            UserProfileModel.CodingKeys.birthday.rawValue: Timestamp(date: birthday),
            UserProfileModel.CodingKeys.bio.rawValue: bio,
            UserProfileModel.CodingKeys.createdAt.rawValue: Timestamp(date: createdAt),
        ]
    }
}
