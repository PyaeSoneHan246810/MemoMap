//
//  UserRowView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    let userProfile: UserProfileData?
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    @State private var viewModel: UserRowViewModel = .init()
    var showActionButton: Bool {
        guard let currentUserId = viewModel.currentUserId, let userId = userProfile?.id, currentUserId != userId else { return false }
        return true
    }
    var body: some View {
        HStack(spacing: 12.0) {
            profilePhotoView
            userInfoView
            if showActionButton, let userType = viewModel.userType {
                actionButtonView(userType: userType)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            if let userId = userProfile?.id {
                viewModel.listenFollowingsIds(userId: userId)
            }
        }
    }
}

private extension UserRowView {
    var profilePhotoView: some View {
        Group {
            if let userProfilePhotoUrl = userProfile?.profilePhotoUrl {
                Circle()
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .frame(width: 60.0, height: 60.0)
                    .overlay {
                        KFImage(URL(string: userProfilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(.circle)
            } else {
                Image(.profilePlaceholder)
                    .resizable()
                    .frame(width: 60.0, height: 60.0)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    
            }
        }
        .onTapGesture {
            navigateToUserProfile()
        }
    }
    var userInfoView: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            let userDisplayname = userProfile?.displayname
            let username = userProfile?.username
            Text(userDisplayname ?? "Placeholder")
                .font(.callout)
                .fontWeight(.medium)
                .onTapGesture {
                    navigateToUserProfile()
                }
                .redacted(reason: userDisplayname == nil ? .placeholder : [])
            Text(username ?? "Placeholder")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .redacted(reason: username == nil ? .placeholder : [])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder
    func actionButtonView(userType: UserType) -> some View {
        switch userType {
        case .following:
            followingButtonView
        case .notFollowing:
            followButtonView
        }
    }
    var followingButtonView: some View {
        Button("Following") {
            if let userId = userProfile?.id {
                Task { await viewModel.unfollowUser(userId: userId) }
            }
        }
        .secondaryFilledSmallButtonStyle()
        .font(.footnote)
    }
    var followButtonView: some View {
        Button("Follow", systemImage: "person.badge.plus") {
            if let userId = userProfile?.id {
                Task { await viewModel.followUser(userId: userId) }
            }
        }
        .primaryFilledSmallButtonStyle()
        .font(.footnote)
    }
}

private extension UserRowView {
    func navigateToUserProfile() {
        guard let currentUserId = viewModel.currentUserId, let userId = userProfile?.id, currentUserId != userId else { return }
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: userId)
        self.userProfileScreenModel = userProfileScreenModel
    }
}

#Preview {
    UserRowView(
        userProfile: UserProfileData.preview1,
        userProfileScreenModel: .constant(nil)
    )
}

#Preview {
    UserRowView(
        userProfile: UserProfileData.preview1,
        userProfileScreenModel: .constant(nil)
    )
}
