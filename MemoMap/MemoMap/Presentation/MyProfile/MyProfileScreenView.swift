//
//  MyProfileScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct MyProfileScreenView: View {
    @State private var myProfileViewModel: MyProfileViewModel = .init()
    @Environment(UserViewModel.self) private var userViewModel: UserViewModel
    private var userProfile: UserProfileData? {
        userViewModel.userProfile
    }
    private var followersCount: Int {
        userViewModel.followersCount
    }
    private var followingsCount: Int {
        userViewModel.followingsCount
    }
    private var totalHeartsCount: Int {
        myProfileViewModel.totalHeartsCount
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
                if !myProfileViewModel.memories.isEmpty {
                    memoriesView
                } else {
                    emptyPublicMemoriesView
                }
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .background(scrollViewBackgroundColor)
        .background(Color(uiColor: .secondarySystemBackground))
        .toolbar {
            toolbarContentView
        }
        .onAppear {
            myProfileViewModel.listenUserPublicMemories()
        }
        .task {
            await myProfileViewModel.getTotalHeartsCount()
        }
    }
}

private extension MyProfileScreenView {
    var scrollViewBackgroundColor: Color {
        myProfileViewModel.memories.isEmpty ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground)
    }
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                SettingsScreenView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
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
            editButtonView
        }
        .padding(.top, 16.0)
        .padding(.horizontal, 16.0)
    }
    var editButtonView: some View {
        Button("Edit profile", systemImage: "pencil") {
            
        }
        .primaryFilledSmallButtonStyle()
    }
    var profileInfoView: some View {
        ProfileInfoView(
            displayName: userProfile?.displayname ?? "Placeholder",
            username: userProfile?.username ?? "@placeholder",
            email: userProfile?.emailAddress ?? "placeholder@example.com",
            bio: userProfile?.bio ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            birthday: userProfile?.birthday.formatted(date: .abbreviated, time: .omitted) ?? "placeholder",
            joined: userProfile?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "placeholder",
            followersCount: followersCount,
            followingCount: followingsCount,
            heartsCount: totalHeartsCount,
            profileInfoType: .ownUser
        )
        .padding(16)
        .redacted(reason: userProfile == nil ? .placeholder : [])
    }
    var memoriesView: some View {
        MemoryPostsView(
            memories: myProfileViewModel.memories,
            userProfileScreenModel: .constant(nil)
        )
        .padding(.vertical, 16.0)
    }
    var emptyPublicMemoriesView: some View {
        EmptyContentView(
            image: .emptyMemories,
            title: "There is no public memories yet!",
            description: "Share your favorite moments to let others discover them!"
        )
    }
}

#Preview {
    @Previewable @State var userViewModel: UserViewModel = .init()
    NavigationStack {
        MyProfileScreenView()
    }
    .environment(userViewModel)
}
