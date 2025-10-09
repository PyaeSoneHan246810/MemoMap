//
//  UserProfileView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI
import Kingfisher

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
        let userProfile: UserProfileData?
        let userType: UserType
    }
    static let previewUserProfileInfo1: UserProfileInfo = .init(
        userProfile: UserProfileData.preview1,
        userType: .following
    )
    static let previewUserProfileInfo2: UserProfileInfo = .init(
        userProfile: UserProfileData.preview1,
        userType: .unfollowed
    )
}

private extension UserProfileView {
    var profilePhotoView: some View {
        Group {
            if let userProfilePhotoUrl = userProfileInfo.userProfile?.profilePhotoUrl {
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
            let userDisplayname = userProfileInfo.userProfile?.displayname
            let username = userProfileInfo.userProfile?.username
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
