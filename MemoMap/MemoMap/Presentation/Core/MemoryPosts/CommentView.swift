//
//  CommentView.swift
//  MemoMap
//
//  Created by Dylan on 26/9/25.
//

import SwiftUI

struct CommentView: View {
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    let onUserInfoTapped: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(spacing: 8.0) {
                userProfilePhotoView
                commentInfoView
            }
            commentTextView
        }
    }
}

private extension CommentView {
    var userProfilePhotoView: some View {
        Image(.profilePlaceholder)
            .resizable()
            .scaledToFit()
            .frame(width: 44, height: 44)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .onTapGesture {
                onUserInfoTapped()
            }
    }
    var commentInfoView: some View {
        VStack(alignment: .leading, spacing: 0.0) {
            Text("Display Name")
                .font(.subheadline)
                .fontWeight(.medium)
                .onTapGesture {
                    onUserInfoTapped()
                }
            Text("2 hours ago")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    var commentTextView: some View {
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            .font(.callout)
            .opacity(0.8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CommentView(
        userProfileScreenModel: .constant(nil),
        onUserInfoTapped: {}
    )
}
