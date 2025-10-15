//
//  UserProfileScreenView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct UserProfileScreenModel: Hashable {
    let userId: String
}

struct UserProfileScreenView: View {
    let userProfileScreenModel: UserProfileScreenModel
    @State private var viewModel: UserProfileViewModel = .init()
    private var userId: String {
        userProfileScreenModel.userId
    }
    private var userProfile: UserProfileData? {
        viewModel.userProfile
    }
    private var memories: [MemoryData] {
        viewModel.memories
    }
    private var userType: UserType? {
        viewModel.userType
    }
    private var isFollowingUser: Bool {
        userType == .following
    }
    private var followingsCount: Int {
        viewModel.followingsCount
    }
    private var followersCount: Int {
        viewModel.followersCount
    }
    private var totalHeartsCount: Int {
        viewModel.totalHeartsCount
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    profilePhotosView
                    buttonSectionView
                    profileInfoView
                }
                .background(Color(uiColor: .systemBackground))
                if isFollowingUser {
                    memoriesView
                } else {
                    followUserView
                }
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .background(scrollViewBackgroundColor)
        .toolbarVisibility(.hidden, for: .tabBar)
        .onAppear {
            viewModel.listenFollowingsIds(userId: userId)
        }
        .task {
            await getUserData()
        }
    }
}

private extension UserProfileScreenView {
    var scrollViewBackgroundColor: Color {
        isFollowingUser && !memories.isEmpty ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground)
    }
    var profilePhotosView: some View {
        ProfileCoverPhotoView(
            coverPhoto: userProfile?.coverPhotoUrl
        )
        .overlay(alignment: .bottomLeading) {
            ProfilePhotoView(
                profilePhoto: userProfile?.profilePhotoUrl
            )
            .padding(.leading, 16.0)
            .offset(y: 60.0)
        }
    }
    var buttonSectionView: some View {
        HStack {
            Spacer()
            if isFollowingUser {
                followingButtonView
            } else {
                followButtonView
            }
        }
        .padding(.top, 16.0)
        .padding(.horizontal, 16.0)
    }
    var followingButtonView: some View {
        Button("Following") {
            Task {
                await viewModel.unfollowUser(userId: userId)
            }
        }
        .secondaryFilledSmallButtonStyle()
    }
    var followButtonView: some View {
        Button("Follow", systemImage: "person.badge.plus") {
            Task {
                await viewModel.followUser(userId: userId)
            }
        }
        .primaryFilledSmallButtonStyle()
    }
    var profileInfoView: some View {
        ProfileInfoView(
            id: userProfile?.id,
            displayName: userProfile?.displayname ?? "Placeholder",
            username: userProfile?.username ?? "@placeholder",
            email: userProfile?.emailAddress ?? "placeholder@example.com",
            bio: userProfile?.bio ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            birthday: userProfile?.birthday.formatted(date: .abbreviated, time: .omitted) ?? "placeholder",
            joined: userProfile?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "placeholder",
            followersCount: followersCount,
            followingCount: followingsCount,
            heartsCount: totalHeartsCount,
            profileInfoType: .otherUser
        )
        .padding(16)
        .redacted(reason: userProfile == nil ? .placeholder : [])
    }
    var followUserView: some View {
        VStack(spacing: 16.0) {
            Image(.followUser)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
                .foregroundStyle(.secondary)
            Text("Follow the user to see their public memories")
                .multilineTextAlignment(.center)
        }
        .frame(width: 240.0)
    }
    @ViewBuilder
    var memoriesView: some View {
        if memories.isEmpty {
            EmptyContentView(
                image: .emptyMemories,
                title: "There is no public memories yet!",
                description: "This user hasn’t shared any memories to be discovered."
            )
        } else {
            MemoryPostsView(
                memories: memories,
                userProfileScreenModel: .constant(nil)
            )
            .padding(.vertical, 16.0)
        }
    }
}

private extension UserProfileScreenView {
    func getUserData() async {
        await viewModel.getUserProfile(userId: userId)
        await viewModel.getFollowingsCount(userId: userId)
        await viewModel.getFollowersCount(userId: userId)
        await viewModel.getTotalHeartsCount(userId: userId)
        await viewModel.getUserPublicMemories(userId: userId)
    }
}

#Preview {
    UserProfileScreenView(
        userProfileScreenModel: .init(userId: "")
    )
}
