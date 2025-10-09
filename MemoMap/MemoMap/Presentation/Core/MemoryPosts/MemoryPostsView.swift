//
//  MemoryPostsView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct MemoryPostsView: View {
    let memoryPosts: [MemoryPost]
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    var body: some View {
        LazyVStack(spacing: 16.0) {
            ForEach(memoryPosts) { memoryPost in
                let memoryPostInfo = getMemoryPostInfo(from: memoryPost)
                MemoryPostView(
                    memoryPostInfo: memoryPostInfo,
                    userProfileScreenModel: $userProfileScreenModel
                )
            }
        }
    }
}

private extension MemoryPostsView {
    func getMemoryPostInfo(from memoryPost: MemoryPost) -> MemoryPostView.MemoryPostInfo {
        let memoryPostInfo = MemoryPostView.MemoryPostInfo(
            userProfile: memoryPost.userProfile,
            memory: memoryPost.memory
        )
        return memoryPostInfo
    }
}

#Preview {
    ScrollView(.vertical) {
        MemoryPostsView(
            memoryPosts: [
                MemoryPost(
                    memory: MemoryData.preview1,
                    userProfile: UserProfileData.preview1
                )
            ],
            userProfileScreenModel: .constant(nil)
        )
    }
    .scrollIndicators(.hidden)
    .background(Color(uiColor: .secondarySystemBackground))
}
