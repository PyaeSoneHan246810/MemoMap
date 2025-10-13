//
//  ProfileInfoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfileInfoView: View {
    let displayName: String
    let username: String
    let email: String
    let bio: String
    let birthday: String
    let joined: String
    let followersCount: Int
    let followingCount: Int
    let heartsCount: Int
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
            Text(bio)
                .font(.subheadline)
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
                countInfoView(count: heartsCount, label: "Hearts")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            displayName: UserProfileData.preview1.displayname,
            username: UserProfileData.preview1.username,
            email: UserProfileData.preview1.emailAddress,
            bio: UserProfileData.preview1.bio,
            birthday: UserProfileData.preview1.birthday.formatted(date: .abbreviated, time: .omitted),
            joined: UserProfileData.preview1.createdAt.formatted(date: .abbreviated, time: .omitted),
            followersCount: 0,
            followingCount: 0,
            heartsCount: 0,
        )
    }
}
