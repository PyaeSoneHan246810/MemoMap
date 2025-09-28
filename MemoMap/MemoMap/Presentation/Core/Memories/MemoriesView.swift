//
//  MemoriesView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct MemoriesView: View {
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    var body: some View {
        LazyVStack(spacing: 16.0) {
            ForEach(1...5, id: \.self) { _ in
                MemoryPostView(
                    memoryPostInfo: MemoryPostView.previewMemoryPostInfo,
                    userProfileScreenModel: $userProfileScreenModel
                )
            }
        }
    }
}

#Preview {
    ScrollView(.vertical) {
        MemoriesView(
            userProfileScreenModel: .constant(nil)
        )
    }
    .scrollIndicators(.hidden)
    .background(Color(uiColor: .secondarySystemBackground))
}
