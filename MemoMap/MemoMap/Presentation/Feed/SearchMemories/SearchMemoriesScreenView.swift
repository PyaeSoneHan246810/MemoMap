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
        searchResultsView
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
    }
    var searchButtonView: some View {
        Button("Search") {
            Task {
                await viewModel.searchMemories()
            }
        }
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
    func searchMemoriesView(memories: [MemoryData]) -> some View {
        if memories.isEmpty {
            EmptyContentView(
                image: .emptyMemories,
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
