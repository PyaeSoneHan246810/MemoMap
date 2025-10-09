//
//  UserComment.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

struct UserComment: Identifiable {
    let comment: CommentData
    let userProfile: UserProfileData?
    var id: String {
        comment.id
    }
}

extension UserComment {
    static let preview1: UserComment = UserComment(
        comment: CommentData.preview1,
        userProfile: UserProfileData.preview1
    )
}
