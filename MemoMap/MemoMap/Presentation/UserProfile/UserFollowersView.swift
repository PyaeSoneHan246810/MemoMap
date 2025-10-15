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
        followersView
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
    var followersView: some View {
        if viewModel.followerUsers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Followers",
                description: "The user doesn't have any followers."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(viewModel.followerUsers) { followerUser in
                        UserRowView(
                            userProfile: followerUser,
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
