//
//  CommunityScreenView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI

struct CommunityScreenView: View {
    @State private var selectedConnectionType: ConnectionType = .followers
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
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
                Label("Search", systemImage: "person.badge.plus")
            }
        }
    }
    var connectionTypePickerView: some View {
        Picker("Connection Type", selection: $selectedConnectionType) {
            Text("10 Followers")
                .tag(ConnectionType.followers)
            Text("10 Followings")
                .tag(ConnectionType.following)
            Text("4 Mutuals")
                .tag(ConnectionType.mutuals)
        }
        .pickerStyle(.segmented)
        .padding(16.0)
    }
    var connectionsView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(0...5, id: \.self) { _ in
                    UserProfileView(
                        userProfileInfo: UserProfileView.previewUserProfileInfo1,
                        userProfileScreenModel: $userProfileScreenModel
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(16.0)
    }
}

#Preview {
    NavigationStack {
        CommunityScreenView()
    }
}
