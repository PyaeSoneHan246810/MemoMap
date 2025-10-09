//
//  UserHeart.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

struct UserHeart: Identifiable {
    let heart: HeartData
    let userProfile: UserProfileData?
    var id: String {
        heart.id
    }
}
