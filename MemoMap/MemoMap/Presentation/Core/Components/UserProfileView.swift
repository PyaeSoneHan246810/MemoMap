//
//  UserProfileView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI

struct UserProfileView: View {
    let userProfileInfo: UserProfileInfo
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    var body: some View {
        HStack(spacing: 12.0) {
            profilePhotoView
            userInfoView
            actionButtonView
        }
        .frame(maxWidth: .infinity)
    }
}

extension UserProfileView {
    enum UserType {
        case following
        case unfollowed
        case mutual
    }
    struct UserProfileInfo {
        let profilePhotoUrl: String
        let displayName: String
        let username: String
        let userType: UserType
    }
    static let previewUserProfileInfo1: UserProfileInfo = .init(
        profilePhotoUrl: "",
        displayName: "",
        username: "",
        userType: .following
    )
    static let previewUserProfileInfo2: UserProfileInfo = .init(
        profilePhotoUrl: "",
        displayName: "",
        username: "",
        userType: .unfollowed
    )
}

private extension UserProfileView {
    var profilePhotoView: some View {
        Image(.profilePlaceholder)
            .resizable()
            .frame(width: 60.0, height: 60.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .onTapGesture {
                navigateToUserProfile()
            }
    }
    var userInfoView: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            Text("Display Name")
                .font(.callout)
                .fontWeight(.medium)
                .onTapGesture {
                    navigateToUserProfile()
                }
            Text("@username")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    @ViewBuilder
    var actionButtonView: some View {
        switch userProfileInfo.userType {
        case .following:
            followingButtonView
        case .unfollowed:
            followButtonView
        case .mutual:
            followingButtonView
        }
    }
    var followingButtonView: some View {
        Button("Following") {
            
        }
        .secondaryFilledSmallButtonStyle()
        .font(.footnote)
    }
    var followButtonView: some View {
        Button("Follow", systemImage: "person.badge.plus") {
            
        }
        .primaryFilledSmallButtonStyle()
        .font(.footnote)
    }
}

private extension UserProfileView {
    func navigateToUserProfile() {
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: "userId")
        self.userProfileScreenModel = userProfileScreenModel
    }
}

#Preview {
    UserProfileView(
        userProfileInfo: UserProfileView.previewUserProfileInfo1,
        userProfileScreenModel: .constant(nil)
    )
}

#Preview {
    UserProfileView(
        userProfileInfo: UserProfileView.previewUserProfileInfo2,
        userProfileScreenModel: .constant(nil)
    )
}
