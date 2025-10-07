//
//  MemoryTagsView.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI
import WrappingHStack

struct MemoryTagsView: View {
    let tags: [String]
    var body: some View {
        WrappingHStack(alignment: .leading, horizontalSpacing: 4.0, verticalSpacing: 4.0) {
            ForEach(tags, id: \.self) { tag in
                MemoryTagView(text: tag)
            }
        }
    }
}

#Preview {
    MemoryTagsView(
        tags: ["Tag 1", "Tag 2", "Tag 3", "Tag 4"]
    )
}
