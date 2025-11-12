//
//  SearchMemoriesScreenView.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import SwiftUI
import SearchBar

struct SearchMemoriesScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SearchMemoriesViewModel = .init()
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.trimmedSearchText.isEmpty {
                if viewModel.recentMemorySearches.isEmpty {
                    searchInitialView
                } else {
                    recentSearchesView
                }
            } else {
                searchResultsView
            }
        }
        .navigationTitle("Search Memories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            toolbarContentView
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .safeAreaInset(edge: .top) {
            topBarView
        }
        .onAppear {
            viewModel.deleteRecentMemorySearchesOlderThanOneWeek()
            viewModel.getRecentMemorySearches()
        }
    }
}

private extension SearchMemoriesScreenView {
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
            prompt: "Enter location name"
        )
        .searchBarStyle(.capsule)
        .searchBarMaterial(.glass)
        .searchBarCancelButtonDisplayMode(.never)
        .searchBarTextContentType(.location)
        .searchBarAutoCorrectionType(.no)
        .searchBarAutoCapitalizationType(.none)
        .onChange(of: viewModel.searchText) {
            if viewModel.trimmedSearchText.isEmpty {
                viewModel.resetSearchState()
                viewModel.getRecentMemorySearches()
            }
        }
    }
    var searchButtonView: some View {
        Button("Search") {
            Task {
                await viewModel.searchMemories()
            }
        }
    }
    var recentSearchesView: some View {
        VStack(spacing: 8.0) {
            recentSearchedHeaderView
            recentMemorySearchesListView
        }
    }
    @ViewBuilder
    var recentSearchedHeaderView: some View {
        HStack {
            Text("Recent Searches")
                .font(.headline)
            Spacer()
            Button("Clear all") {
                viewModel.deleteAllRecentMemorySearches()
                viewModel.getRecentMemorySearches()
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
            .controlSize(.mini)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16.0)
    }
    @ViewBuilder
    var recentMemorySearchesListView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(viewModel.recentMemorySearches) { recentSearch in
                    recentMemorySearchView(recentSearch)
                }
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
        .contentMargins(.vertical, 8.0)
    }
    func recentMemorySearchView(_ recentMemorySearch: RecentMemorySearch) -> some View {
        RecentSearchView(
            searchText: recentMemorySearch.searchText,
            onTextTapped: {
                viewModel.searchText = recentMemorySearch.searchText
            },
            onRemove: {
                viewModel.deleteRecentMemorySearch(recentMemorySearch)
                viewModel.getRecentMemorySearches()
            }
        )
    }
    @ViewBuilder
    var searchResultsView: some View {
        switch viewModel.searchMemoriesDataState {
        case .initial:
            searchInitialView
        case .loading:
            searchLoadingView
        case .success(let memories):
            searchMemoriesView(memories: memories)
        case .failure(let errorDescription):
            searchFailureView(errorDescription: errorDescription)
        }
    }
    var searchInitialView: some View {
        EmptyContentView(
            image: .searchMemories,
            title: "Search Memories",
            description: "Enter a location name to discover related memories."
        )
    }
    var searchLoadingView: some View {
        ZStack {
            ProgressView().controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    func searchFailureView(errorDescription: String) -> some View {
        ErrorView(errorDescription: errorDescription)
    }
    @ViewBuilder
    func searchMemoriesView(memories: [MemoryData]) -> some View {
        if memories.isEmpty {
            EmptyContentView(
                image: .emptyData,
                title: "No Memories Found",
                description: "We couldn’t find any memories related to this location."
            )
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(memories) { memory in
                        MemoryPostView(
                            memory: memory,
                            userProfileScreenModel: $userProfileScreenModel
                        )
                    }
                }
            }
            .disableBouncesVertically()
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        SearchMemoriesScreenView(
            userProfileScreenModel: .constant(nil)
        )
    }
}
