//
//  UserFollowersView.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import SwiftUI

struct UserFollowersView: View {
    @Environment(\.dismiss) private var dismiss
    let userId: String
    @State private var viewModel: UserFollowersViewModel = .init()
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    var body: some View {
        mainContentView
        .navigationTitle("Followers")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(userProfileScreenModel: $0)
        }
        .task {
            await viewModel.getFollowerUsers(of: userId)
        }
    }
}

private extension UserFollowersView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    @ViewBuilder
    var mainContentView: some View {
        switch viewModel.followerUsersDataState {
        case .initial, .loading:
            loadingProgressView
        case .success(let followers):
            followersView(followers)
        case .failure(let errorDescription):
            ErrorView(errorDescription: errorDescription)
        }
    }
    var loadingProgressView: some View {
        ZStack {
            ProgressView().controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    @ViewBuilder
    func followersView(_ followers: [UserProfileData]) -> some View {
        if followers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Followers",
                description: "The user doesn't have any followers."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(followers) { follower in
                        UserRowView(
                            userProfile: follower,
                            userProfileScreenModel: $userProfileScreenModel
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(16.0)
        }
    }
}

#Preview {
    NavigationStack {
        UserFollowersView(
            userId: ""
        )
    }
}
