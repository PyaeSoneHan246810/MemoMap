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
    @State private var searchText: String = ""
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    var body: some View {
        VStack(spacing: 0.0) {
            topBarView
            ZStack(alignment: .top) {
                searchResultsView
                //recentSearchesView
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
        }
        .padding(.leading, 12.0)
        .padding(.trailing, 16.0)
    }
    var backButtonView: some View {
        Button {
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
        SearchBar(text: $searchText)
            .searchBarStyle(.capsule)
    }
    var recentSearchesView: some View {
        VStack(spacing: 0.0) {
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
            if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                VStack {
                    Text("Results for \"\(searchText)\"")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8.0)
            }
            ScrollView(.vertical) {
                LazyVStack(spacing: 16.0) {
                    ForEach(1...5, id: \.self) { _ in
                        UserProfileView(
                            userProfileInfo: UserProfileView.previewUserProfileInfo1,
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
}

#Preview {
    NavigationStack {
        SearchUsersScreenView()
    }
}
