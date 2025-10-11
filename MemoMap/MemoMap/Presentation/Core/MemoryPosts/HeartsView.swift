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
        heartsScrollView
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
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.semibold)
            }
        }
    }
    var heartsScrollView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ForEach(viewModel.userHearts) { userHeart in
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
