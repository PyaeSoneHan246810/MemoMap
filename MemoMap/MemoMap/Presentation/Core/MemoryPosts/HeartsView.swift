//
//  HeartsView.swift
//  MemoMap
//
//  Created by Dylan on 28/9/25.
//

import SwiftUI

struct HeartsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    @State private var viewModel: HeartsViewModel = .init()
    let memoryId: String
    var body: some View {
        mainContentView
        .navigationTitle("Hearts")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(userProfileScreenModel: $0)
        }
        .task {
            await viewModel.getUserHearts(memoryId: memoryId)
        }
    }
}

private extension HeartsView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    @ViewBuilder
    var mainContentView: some View {
        switch viewModel.userHeartsDataState {
        case .initial, .loading:
            loadingProgressView
        case .success(let userHearts):
            userHeartsView(userHearts)
        case .failure(let errorDescription):
            ErrorView(errorDescription: errorDescription)
        }
    }
    var loadingProgressView: some View {
        ZStack {
            ProgressView().controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    func userHeartsView(_ userHearts: [UserHeart]) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(userHearts) { userHeart in
                    UserRowView(
                        userProfile: userHeart.userProfile,
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
        HeartsView(
            memoryId: ""
        )
    }
}
