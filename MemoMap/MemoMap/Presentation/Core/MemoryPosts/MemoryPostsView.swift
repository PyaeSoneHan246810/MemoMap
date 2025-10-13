//
//  MemoryPostsView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct MemoryPostsView: View {
    let memories: [MemoryData]
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    var body: some View {
        LazyVStack(spacing: 16.0) {
            ForEach(memories) { memory in
                MemoryPostView(
                    memory: memory,
                    userProfileScreenModel: $userProfileScreenModel
                )
            }
        }
    }
}

#Preview {
    ScrollView(.vertical) {
        MemoryPostsView(
            memories: MemoryData.previews,
            userProfileScreenModel: .constant(nil)
        )
    }
    .scrollIndicators(.hidden)
    .background(Color(uiColor: .secondarySystemBackground))
}
