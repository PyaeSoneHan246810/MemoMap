//
//  AddMemoryView.swift
//  MemoMap
//
//  Created by Dylan on 27/9/25.
//

import SwiftUI
import PhotosUI
import WrappingHStack

struct AddMemoryView: View {
    @Binding var memoryMediaItems: [MemoryMediaItem]
    @Binding var memoryTitle: String
    @Binding var memoryDescription: String
    @Binding var memoryTags: [String]
    @Binding var memoryDateTime: Date
    @Binding var isMemoryPublic: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            AddMemoryMediaView(
                memoryMediaItems: $memoryMediaItems
            )
            EditMemoryInfoView(
                memoryTitle: $memoryTitle,
                memoryDescription: $memoryDescription,
                memoryTags: $memoryTags,
                memoryDateTime: $memoryDateTime,
                isMemoryPublic: $isMemoryPublic
            )
            .padding(.horizontal, 16.0)
        }
    }
}

#Preview {
    NavigationStack {
        AddMemoryView(
            memoryMediaItems: .constant([]),
            memoryTitle: .constant(""),
            memoryDescription: .constant(""),
            memoryTags: .constant([]),
            memoryDateTime: .constant(.now),
            isMemoryPublic: .constant(true)
        )
    }
}

