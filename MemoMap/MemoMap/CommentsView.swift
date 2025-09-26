//
//  CommentScreenView.swift
//  MemoMap
//
//  Created by Dylan on 26/9/25.
//

import SwiftUI

struct CommentsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @State private var userProfileScreenModel: UserProfileScreenModel? = nil
    @State private var comment: String = ""
    private var toolbarbackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    var body: some View {
        NavigationStack {
            commentsScrollView
            .safeAreaInset(edge: .bottom) {
                bottomBarView
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackgroundVisibility(.visible, for: .navigationBar)
            .toolbarBackground(toolbarbackground, for: .navigationBar)
            .toolbar {
                toolbarContentView
            }
            .navigationDestination(item: $userProfileScreenModel) {
                UserProfileScreenView(userProfileScreenModel: $0)
            }
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
                ForEach(1...10, id: \.self) { _ in
                    CommentView(
                        userProfileScreenModel: $userProfileScreenModel,
                        onUserInfoTapped: {
                            navigateToUserProfile()
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
        TextField("Write a comment...", text: $comment, axis: .vertical)
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
    func navigateToUserProfile() {
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: "userId")
        self.userProfileScreenModel = userProfileScreenModel
    }
}

#Preview {
    CommentsView()
}
