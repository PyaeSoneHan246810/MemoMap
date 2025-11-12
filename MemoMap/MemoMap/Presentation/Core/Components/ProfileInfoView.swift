//
//  ProfileInfoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfileInfoView: View {
    let id: String?
    let displayName: String
    let username: String
    let email: String
    let bio: String?
    let birthday: String
    let joined: String
    let followersCount: Int
    let followingCount: Int
    let heartsCount: Int
    let profileInfoType: ProfileInfoType
    @State private var selectedSheetType: SheetType? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(username)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(email)
                    .font(.footnote)
                    .tint(.primary)
            }
            if let bio {
                Text(bio)
                    .font(.subheadline)
            }
            HStack(spacing: 8.0) {
                HStack(spacing: 4.0) {
                    Image(systemName: "birthday.cake.fill")
                        .foregroundStyle(.secondary)
                    Text(birthday)
                }
                HStack(spacing: 4.0) {
                    Text("Joined")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Text(joined)
                }
            }
            .font(.footnote)
            HStack(spacing: 8.0) {
                switch profileInfoType {
                case .ownUser:
                    NavigationLink {
                        CommunityScreenView(
                            selectedConnectionType: .followers
                        )
                    } label: {
                        countInfoView(count: followersCount, label: "Followers")
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        CommunityScreenView(
                            selectedConnectionType: .following
                        )
                    } label: {
                        countInfoView(count: followingCount, label: "Followings")
                    }
                    .buttonStyle(.plain)
                case .otherUser:
                    countInfoView(count: followersCount, label: "Followers")
                        .onTapGesture {
                            if id != nil {
                                selectedSheetType = .followers
                            }
                            
                        }
                    countInfoView(count: followingCount, label: "Followings")
                        .onTapGesture {
                            if id != nil {
                                selectedSheetType = .followings
                            }
                        }
                }
                countInfoView(count: heartsCount, label: "Hearts")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sheet(item: $selectedSheetType) { sheetType in
            Group {
                if let userId = id {
                    switch sheetType {
                    case .followers:
                        followersSheetView(userId: userId)
                    case .followings:
                        followingsSheetView(userId: userId)
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

extension ProfileInfoView {
    enum ProfileInfoType {
        case ownUser
        case otherUser
    }
    enum SheetType: String, Identifiable {
        case followers = "Followers"
        case followings = "Followings"
        var id: String {
            self.rawValue
        }
    }
}

private extension ProfileInfoView {
    func followersSheetView(userId: String) -> some View {
        NavigationStack {
            UserFollowersView(userId: userId)
        }
    }
    func followingsSheetView(userId: String) -> some View {
        NavigationStack {
            UserFollowingsView(userId: userId)
        }
    }
}

private extension ProfileInfoView {
    func countInfoView(count: Int, label: String) -> some View {
        HStack(spacing: 4.0) {
            Text(count.description)
                .font(.callout)
                .fontWeight(.medium)
            Text(label)
                .font(.footnote)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileInfoView(
            id: UserProfileData.preview1.id,
            displayName: UserProfileData.preview1.displayname,
            username: UserProfileData.preview1.username,
            email: UserProfileData.preview1.emailAddress,
            bio: UserProfileData.preview1.bio,
            birthday: UserProfileData.preview1.birthday.formatted(date: .abbreviated, time: .omitted),
            joined: UserProfileData.preview1.createdAt.formatted(date: .abbreviated, time: .omitted),
            followersCount: 0,
            followingCount: 0,
            heartsCount: 0,
            profileInfoType: .ownUser
        )
    }
}
