//
//  UserProfileData.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

struct UserProfileData: Identifiable {
    let id: String
    let emailAddress: String
    let username: String
    let displayname: String
    let profilePhotoUrl: String?
    let coverPhotoUrl: String?
    let birthday: Date
    let bio: String
    let createdAt: Date
}

extension UserProfileData {
    static let preview1: UserProfileData = UserProfileData(
        id: "1",
        emailAddress: "pyaesonehan246810@gmail.com",
        username: "@dylan-2004",
        displayname: "Pyae Sone Han",
        profilePhotoUrl: "https://images.unsplash.com/photo-1758390851311-b009744be513?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        coverPhotoUrl: "https://images.unsplash.com/photo-1743341942781-14f3c65603c4?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        birthday: .now, bio: "iOS Developer in Bangkok",
        createdAt: .now
    )
}
