//
//  CommunityScreenView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI
import TipKit

struct CommunityScreenView: View {
    @Environment(UserViewModel.self) private var userViewModel: UserViewModel
    @State private var communityViewModel: CommunityViewModel = .init()
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    var selectedConnectionType: ConnectionType?
    let searchUsersTip: SearchUsersTip = .init()
    var body: some View {
        VStack(spacing: 0.0) {
            connectionTypePickerView
            connectionsView
        }
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(
                userProfileScreenModel: $0
            )
        }
        .onAppear {
            if let selectedConnectionType {
                communityViewModel.selectedConnectionType = selectedConnectionType
            }
        }
    }
}

extension CommunityScreenView {
    enum ConnectionType: Hashable {
        case followers
        case following
        case mutuals
    }
}

private extension CommunityScreenView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                SearchUsersScreenView()
            } label: {
                Image(systemName: "person.badge.plus")
            }
            .popoverTip(searchUsersTip)
        }
    }
    var connectionTypePickerView: some View {
        Picker("Connection Type", selection: $communityViewModel.selectedConnectionType) {
            Text("\(userViewModel.followersCount) Followers")
                .tag(ConnectionType.followers)
            Text("\(userViewModel.followingsCount) Followings")
                .tag(ConnectionType.following)
            Text("\(userViewModel.mutualsCount) Mutuals")
                .tag(ConnectionType.mutuals)
        }
        .pickerStyle(.segmented)
        .padding(16.0)
    }
    @ViewBuilder
    var connectionsView: some View {
        switch communityViewModel.selectedConnectionType {
        case .followers:
            followersListView
        case .following:
            followingsListView
        case .mutuals:
            mutualListView
        }
    }
    @ViewBuilder
    var followersListView: some View {
        if userViewModel.followerUsers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Followers Yet",
                description: "Once someone follows you, they’ll appear here."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(userViewModel.followerUsers) { user in
                        UserRowView(
                            userProfile: user,
                            userProfileScreenModel: $userProfileScreenModel
                        )
                    }
                }
            }
            .communityScrollViewStyle()
        }
        
    }
    @ViewBuilder
    var followingsListView: some View {
        if userViewModel.followingUsers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "Not Following Anyone",
                description: "When you follows people, you’ll see them here."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(userViewModel.followingUsers) { user in
                        UserRowView(
                            userProfile: user,
                            userProfileScreenModel: $userProfileScreenModel
                        )
                    }
                }
            }
            .communityScrollViewStyle()
        }
    }
    @ViewBuilder
    var mutualListView: some View {
        if userViewModel.mutualUsers.isEmpty {
            EmptyContentView(
                image: .connection,
                title: "No Mutuals Yet",
                description: "Follow each other to see mutual connections here."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(userViewModel.mutualUsers) { user in
                        UserRowView(
                            userProfile: user,
                            userProfileScreenModel: $userProfileScreenModel
                        )
                    }
                }
            }
            .communityScrollViewStyle()
        }
    }
}

private extension View {
    func communityScrollViewStyle() -> some View {
        self
            .disableBouncesVertically()
            .scrollIndicators(.hidden)
            .contentMargins(16.0)
    }
}

#Preview {
    @Previewable @State var userViewModel: UserViewModel = .init()
    NavigationStack {
        CommunityScreenView()
    }
    .environment(userViewModel)
}
