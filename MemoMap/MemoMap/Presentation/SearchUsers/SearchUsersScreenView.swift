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
        VStack(spacing: 0.0) {
            topBarView
            ZStack(alignment: .top) {
                if viewModel.trimmedSearchText.isEmpty {
                    recentSearchesView
                } else {
                    searchResultsView
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(
                userProfileScreenModel: $0
            )
        }
    }
}

private extension SearchUsersScreenView {
    var topBarView: some View {
        HStack(spacing: 0.0) {
            backButtonView
            searchBarView
            if !viewModel.trimmedSearchText.isEmpty {
                searchButtonView
            }
        }
        .padding(.leading, 12.0)
        .padding(.trailing, 16.0)
    }
    var backButtonView: some View {
        Button {
            viewModel.clearSearchText()
            viewModel.resetSearchState()
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .imageScale(.large)
                .fontWeight(.semibold)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .controlSize(.large)
    }
    var searchBarView: some View {
        SearchBar(text: $viewModel.searchText)
            .searchBarStyle(.capsule)
            .searchBarMaterial(.glass)
            .searchBarCancelButtonDisplayMode(.never)
            .searchBarTextContentType(.name)
            .searchBarAutoCorrectionType(.no)
            .searchBarAutoCapitalizationType(.none)
            .onChange(of: viewModel.searchText) {
                if viewModel.trimmedSearchText.isEmpty {
                    viewModel.resetSearchState()
                }
            }
    }
    var searchButtonView: some View {
        Button("Search") {
            Task { await viewModel.searchUsers() }
        }
    }
    var recentSearchesView: some View {
        VStack(spacing: 0.0) {
            recentSearchedHeaderView
            recentSearchesListView
        }
    }
    var recentSearchedHeaderView: some View {
        HStack {
            Text("Recent Searches")
                .font(.headline)
            Spacer()
            Button("Clear all") {
                
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
            .controlSize(.mini)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16.0)
        .padding(.bottom, 8.0)
    }
    var recentSearchesListView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(1...5, id: \.self) { _ in
                    recentSearchTextView(
                        searchText: "Test"
                    )
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
        .contentMargins(.top, 8.0)
        .contentMargins(.bottom, 16.0)
    }
    func recentSearchTextView(searchText: String) -> some View {
        HStack {
            Text(searchText)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "xmark")
            }
            .foregroundStyle(.primary)
            .controlSize(.small)
        }
    }
    var searchResultsView: some View {
        VStack(spacing: 0.0) {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    var searchResultsHeaderView: some View {
        VStack {
            Text("Results for \"\(viewModel.trimmedSearchText)\"")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16.0)
        .padding(.vertical, 8.0)
    }
    var searchInitialView: some View {
        EmptyView()
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
    @ViewBuilder
    func searchUsersListView(users: [UserProfileData]) -> some View {
        if !viewModel.trimmedSearchText.isEmpty {
            searchResultsHeaderView
        }
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
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
        .contentMargins(.top, 8.0)
        .contentMargins(.bottom, 16.0)
    }
}

#Preview {
    NavigationStack {
        SearchUsersScreenView()
    }
}
