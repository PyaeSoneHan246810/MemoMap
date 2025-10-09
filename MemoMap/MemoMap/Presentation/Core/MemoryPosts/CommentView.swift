//
//  CommentView.swift
//  MemoMap
//
//  Created by Dylan on 26/9/25.
//

import SwiftUI
import Kingfisher

struct CommentView: View {
    let userComment: UserComment
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    let onUserInfoTapped: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(spacing: 8.0) {
                userProfilePhotoView
                userInfoView
            }
            commentTextView
        }
    }
}

private extension CommentView {
    var userProfilePhotoView: some View {
        Group {
            if let userProfilePhotoUrl = userComment.userProfile?.profilePhotoUrl {
                Circle()
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .frame(width: 44, height: 44)
                    .overlay {
                        KFImage(URL(string: userProfilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(.circle)
            } else {
                Image(.profilePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            }
        }
        .onTapGesture {
            onUserInfoTapped()
        }
    }
    var userInfoView: some View {
        let userDisplayName = userComment.userProfile?.displayname
        return VStack(alignment: .leading, spacing: 0.0) {
            Text(userDisplayName ?? "Placeholder")
                .font(.subheadline)
                .fontWeight(.medium)
                .onTapGesture {
                    onUserInfoTapped()
                }
                .redacted(reason: userDisplayName == nil ? .placeholder : [])
            Text(userComment.comment.createdAt.formatted())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    var commentTextView: some View {
        Text(userComment.comment.comment)
            .font(.callout)
            .opacity(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CommentView(
        userComment: UserComment.preview1,
        userProfileScreenModel: .constant(nil),
        onUserInfoTapped: {}
    )
}
