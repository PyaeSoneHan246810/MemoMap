//
//  CommentsView.swift
//  MemoMap
//
//  Created by Dylan on 26/9/25.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    @State private var viewModel: CommentsViewModel = .init()
    let memoryId: String
    var body: some View {
        commentsScrollView
        .safeAreaInset(edge: .bottom) {
            bottomBarView
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .navigationDestination(item: $userProfileScreenModel) {
            UserProfileScreenView(userProfileScreenModel: $0)
        }
        .task {
            await viewModel.getUserComments(memoryId: memoryId)
        }
    }
}

private extension CommentsView {
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
    var commentsScrollView: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 32.0) {
                ForEach(viewModel.userComments) { userComment in
                    CommentView(
                        userComment: userComment,
                        userProfileScreenModel: $userProfileScreenModel,
                        onUserInfoTapped: {
                            navigateToUserProfile(
                                userId: userComment.comment.userId
                            )
                        }
                    )
                }
            }
        }
        .contentMargins(16.0)
        .scrollIndicators(.hidden)
    }
    var bottomBarView: some View {
        HStack(spacing: 4.0) {
            commentTextFieldView
            commentButtonView
        }
        .padding(16.0)
        .background(Color(uiColor: .systemBackground))
    }
    var commentTextFieldView: some View {
        TextField("Write a comment...", text: $viewModel.comment, axis: .vertical)
            .lineLimit(2)
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .overlay {
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(.gray, lineWidth: 1.0)
            }
    }
    var commentButtonView: some View {
        Button {
            Task { await addComment() }
        } label: {
            Image(systemName: "paperplane.fill")
                .imageScale(.large)
                .fontWeight(.semibold)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .controlSize(.large)
    }
}

private extension CommentsView {
    func navigateToUserProfile(userId: String) {
        guard let currentUserId = viewModel.currentUserId, currentUserId != userId else { return }
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: userId)
        self.userProfileScreenModel = userProfileScreenModel
    }
    
    func addComment() async {
        await viewModel.addComment(memoryId: memoryId)
    }
}

#Preview {
    NavigationStack {
        CommentsView(
            memoryId: ""
        )
    }
}
