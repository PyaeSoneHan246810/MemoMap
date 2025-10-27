//
//  UserFollowingsView.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import SwiftUI

struct UserFollowingsView: View {
    @Environment(\.dismiss) private var dismiss
    let userId: String
    @State private var viewModel: UserFollowingsViewModel = .init()
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    var body: some View {
        mainContentView
        .navigationTitle("Followings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(userProfileScreenModel: $0)
        }
        .task {
            await viewModel.getFollowingUsers(of: userId)
        }
    }
}

private extension UserFollowingsView {
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
        switch viewModel.followingUsersDataState {
        case .initial, .loading:
            loadingProgressView
        case .success(let followings):
            followingsView(followings)
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
    func followingsView(_ followings: [UserProfileData]) -> some View {
        if followings.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Followings",
                description: "The user doesn't have any followings."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(followings) { following in
                        UserRowView(
                            userProfile: following,
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
