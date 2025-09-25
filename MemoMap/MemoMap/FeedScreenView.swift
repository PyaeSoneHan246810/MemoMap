//
//  FeedScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct FeedScreenView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    private var toolbarBackgroundColor: Color {
        colorScheme == .light ? .white : .black
    }
    var body: some View {
        memoriesFeedView
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(toolbarBackgroundColor, for: .navigationBar)
        .toolbar {
            toolbarContentView
        }
        .safeAreaInset(edge: .top) {
            postAndSearchBarView
        }
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(
                userProfileScreenModel: $0
            )
        }
    }
}

private extension FeedScreenView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .title) {
            Text("Feed")
                .foregroundStyle(Color(uiColor: .label))
                .font(.title2)
                .fontWeight(.semibold)
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                CommunityScreenView()
            } label: {
                Label("Community", systemImage: "person.3")
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                SettingsScreenView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
    }
    var postAndSearchBarView: some View {
        HStack(spacing: 8.0) {
            postMemoryView
            searchButtonView
        }
        .padding(16.0)
        .background(Color(uiColor: .systemBackground))
    }
    var postMemoryView: some View {
        HStack {
            Image(systemName: "square.and.pencil")
                .imageScale(.large)
            Text("Post your memory here")
                .font(.callout)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 16.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 52.0)
        .background(Color(uiColor: .secondarySystemBackground), in: .capsule)
    }
    var searchButtonView: some View {
        Button {
            
        } label: {
            Circle()
                .frame(width: 52.0, height: 52.0)
                .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                .overlay {
                    Image(systemName: "magnifyingglass")
                }
        }
        .buttonStyle(.plain)
    }
    var memoriesFeedView: some View {
        ScrollView(.vertical) {
            MemoriesView(
                userProfileScreenModel: $userProfileScreenModel
            )
        }
        .scrollIndicators(.hidden)
        .contentMargins(.top, 10.0)
        .contentMargins(.bottom, 16.0)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    NavigationStack {
        FeedScreenView()
    }
}
