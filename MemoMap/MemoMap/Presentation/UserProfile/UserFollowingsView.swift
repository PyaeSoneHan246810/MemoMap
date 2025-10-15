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
        followingsView
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
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.semibold)
            }
        }
    }
    @ViewBuilder
    var followingsView: some View {
        if viewModel.followingUsers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Followings",
                description: "The user doesn't have any followings."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(viewModel.followingUsers) { followingUser in
                        UserRowView(
                            userProfile: followingUser,
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
