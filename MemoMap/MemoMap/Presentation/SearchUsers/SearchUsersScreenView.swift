//
//  SearchUsersScreenView.swift
//  MemoMap
//
//  Created by Dylan on 24/9/25.
//

import SwiftUI
import SearchBar

struct SearchUsersScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    @State private var viewModel: SearchUsersViewModel = .init()
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.trimmedSearchText.isEmpty {
                recentSearchesView
            } else {
                searchResultsView
            }
        }
        .navigationTitle("Search Users")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(
                userProfileScreenModel: $0
            )
        }
        .toolbar {
            toolbarContentView
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .safeAreaInset(edge: .top) {
            topBarView
        }
        .onAppear {
            viewModel.deleteRecentSearchesOlderThanOneWeek()
            viewModel.getRecentSearches()
        }
    }
}

private extension SearchUsersScreenView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                viewModel.clearSearchText()
                viewModel.resetSearchState()
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
        }
    }
    var topBarView: some View {
        HStack(spacing: 0.0) {
            searchBarView
            if !viewModel.trimmedSearchText.isEmpty {
                searchButtonView
            }
        }
        .padding(.horizontal, 12.0)
        .background(Color(uiColor: .systemBackground))
    }
    var searchBarView: some View {
        SearchBar(
            text: $viewModel.searchText,
            prompt: "Search users"
        )
        .searchBarStyle(.capsule)
        .searchBarMaterial(.glass)
        .searchBarCancelButtonDisplayMode(.never)
        .searchBarTextContentType(.name)
        .searchBarAutoCorrectionType(.no)
        .searchBarAutoCapitalizationType(.none)
        .onChange(of: viewModel.searchText) {
            if viewModel.trimmedSearchText.isEmpty {
                viewModel.resetSearchState()
                viewModel.getRecentSearches()
            }
        }
    }
    var searchButtonView: some View {
        Button("Search") {
            Task { await viewModel.searchUsers() }
        }
    }
    var recentSearchesView: some View {
        VStack(spacing: 8.0) {
            recentSearchedHeaderView
            recentSearchesListView
        }
    }
    @ViewBuilder
    var recentSearchedHeaderView: some View {
        if viewModel.recentSearches.isEmpty {
            EmptyView()
        } else {
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                Spacer()
                Button("Clear all") {
                    viewModel.deleteAllRecentSearches()
                    viewModel.getRecentSearches()
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.primary)
                .controlSize(.mini)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16.0)
        }
    }
    @ViewBuilder
    var recentSearchesListView: some View {
        if viewModel.recentSearches.isEmpty {
            searchInitialView
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(viewModel.recentSearches) { recentSearch in
                        recentSearchView(recentSearch)
                    }
                }
            }
            .disableBouncesVertically()
            .scrollIndicators(.hidden)
            .contentMargins(.horizontal, 16.0)
            .contentMargins(.vertical, 8.0)
        }
    }
    func recentSearchView(_ recentSearch: RecentSearch) -> some View {
        HStack {
            Text(recentSearch.searchText)
            Spacer()
            Button {
                viewModel.deleteRecentSearch(recentSearch)
                viewModel.getRecentSearches()
            } label: {
                Image(systemName: "xmark")
            }
            .foregroundStyle(.primary)
            .controlSize(.small)
        }
    }
    @ViewBuilder
    var searchResultsView: some View {
        switch viewModel.searchUsersDataState {
        case .initial:
            searchInitialView
        case .loading:
            searchLoadingView
        case .success(let users):
            searchUsersListView(users: users)
        case .failure(let errorDescription):
            searchFailureView(errorDescription: errorDescription)
        }
    }
    var searchInitialView: some View {
        EmptyContentView(
            image: .searchUsers,
            title: "Search Users",
            description: "Type a username or display name to find people."
        )
    }
    var searchLoadingView: some View {
        ZStack {
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    func searchFailureView(errorDescription: String) -> some View {
        ZStack {
            Text(errorDescription)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    var searchResultsHeaderView: some View {
        Text("Results for \"\(viewModel.trimmedSearchText)\"")
            .font(.headline)
            .padding(.horizontal, 16.0)
    }
    @ViewBuilder
    func searchUsersListView(users: [UserProfileData]) -> some View {
        if users.isEmpty {
            EmptyContentView(
                image: .users,
                title: "No Users Found",
                description: "We couldn’t find any users matching your search."
            )
        } else {
            VStack(alignment: .leading, spacing: 8.0) {
                searchResultsHeaderView
                ScrollView(.vertical) {
                    LazyVStack(spacing: 16.0) {
                        ForEach(users) { userProfile in
                            UserRowView(
                                userProfile: userProfile,
                                userProfileScreenModel: $userProfileScreenModel
                            )
                        }
                    }
                }
                .disableBouncesVertically()
                .scrollIndicators(.hidden)
                .contentMargins(.horizontal, 16.0)
                .contentMargins(.vertical, 8.0)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchUsersScreenView()
    }
}
