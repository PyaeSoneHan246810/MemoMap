//
//  ProfileScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import SwiftUIIntrospect

struct ProfileScreenView: View {
    @State private var viewModel: ProfileViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    profilePhotosView
                    buttonSectionView
                    profileInfoView
                }
                .background(Color(uiColor: .systemBackground))
                memoriesView
            }
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
            scrollView.bouncesVertically = false
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .background(Color(uiColor: .secondarySystemBackground))
        .toolbar {
            toolbarContentView
        }
        .onAppear {
            viewModel.listenUserProfile()
        }
    }
}

private extension ProfileScreenView {
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
            coverPhoto: viewModel.userProfileData?.coverPhotoUrl
        )
        .overlay(alignment: .bottomLeading) {
            ProfilePhotoView(
                profilePhoto: viewModel.userProfileData?.profilePhotoUrl
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
        let userProfileData = viewModel.userProfileData
        return ProfileInfoView(
            displayName: userProfileData?.displayname ?? "Placeholder",
            username: userProfileData?.username ?? "@placeholder",
            email: userProfileData?.emailAddress ?? "placeholder@example.com",
            bio: userProfileData?.bio ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            birthday: userProfileData?.birthday.formatted(date: .abbreviated, time: .omitted) ?? "placeholder",
            joined: userProfileData?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "placeholder"
        )
        .padding(16)
        .redacted(reason: userProfileData == nil ? .placeholder : [])
    }
    var memoriesView: some View {
        MemoriesView(
            userProfileScreenModel: .constant(nil)
        )
        .padding(.vertical, 16.0)
    }
}

#Preview {
    NavigationStack {
        ProfileScreenView()
    }
}
