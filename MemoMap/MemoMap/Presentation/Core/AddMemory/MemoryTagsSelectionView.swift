//
//  MemoryTagsSelectionView.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI
import WrappingHStack

struct MemoryTagsSelectionView: View {
    var tags: [String]
    @Binding var selectedTags: [String]
    var body: some View {
        ScrollView(.vertical) {
            WrappingHStack(alignment: .leading, horizontalSpacing: 8.0, verticalSpacing: 12.0) {
                ForEach(tags, id: \.self) { tag in
                    let isTagSelected = selectedTags.contains(tag)
                    MemoryTagView(tag: tag, isSelected: isTagSelected)
                        .onTapGesture {
                            toggleSelection(tag: tag, isSelected: isTagSelected)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(16.0)
        .navigationTitle("Add tags")
    }
}

private extension MemoryTagsSelectionView {
    func toggleSelection(tag: String, isSelected: Bool) {
        withAnimation {
            if isSelected {
                selectedTags.removeAll {
                    $0 == tag
                }
            } else {
                selectedTags.append(tag)
            }
        }
    }
}

#Preview {
    MemoryTagsSelectionView(
        tags: StaticData.tags,
        selectedTags: .constant([])
    )
}
