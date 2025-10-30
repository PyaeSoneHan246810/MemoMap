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
        mainContentView
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
        .alert(
            isPresented: $viewModel.isAddCommentAlertPresented,
            error: viewModel.addCommentError
        ){
        }
    }
}

private extension CommentsView {
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
        switch viewModel.userCommentsDataState {
        case .initial, .loading:
            loadingProgressView
        case .success(let userComments):
            userCommentsView(userComments)
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
    func userCommentsView(_ userComments: [UserComment]) -> some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 32.0) {
                ForEach(userComments) { userComment in
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
            .textInputAutocapitalization(.never)
            .submitLabel(.done)
            .padding(.horizontal, 16.0)
            .padding(.vertical, 12.0)
            .overlay {
                RoundedRectangle(cornerRadius: 12.0)
                    .stroke(.gray, lineWidth: 1.0)
            }
    }
    @ViewBuilder
    var commentButtonView: some View {
        if viewModel.isAddCommentInProgress {
            ProgressView().controlSize(.large)
        } else {
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
            .disabled(!viewModel.isAddCommentValid)
        }
    }
}

private extension CommentsView {
    func navigateToUserProfile(userId: String) {
        guard let currentUserId = viewModel.userData?.uid, currentUserId != userId else { return }
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
