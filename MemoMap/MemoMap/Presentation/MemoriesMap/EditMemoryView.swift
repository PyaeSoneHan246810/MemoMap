//
//  EditMemoryView.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import SwiftUI

struct EditMemoryInfo {
    var title: String
    var description: String
    var tags: [String]
    var dateTime: Date
    var publicStatus: Bool
}

struct EditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var editMemoryInfo: EditMemoryInfo
    let onSaveClick: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20.0) {
                EditMemoryInfoView(
                    memoryTitle: $editMemoryInfo.title,
                    memoryDescription: $editMemoryInfo.description,
                    memoryTags: $editMemoryInfo.tags,
                    memoryDateTime: $editMemoryInfo.dateTime,
                    isMemoryPublic: $editMemoryInfo.publicStatus
                )
                Button("Save", action: onSaveClick)
                    .primaryFilledLargeButtonStyle()
            }
        }
        .disableBouncesVertically()
        .contentMargins(16.0)
        .scrollIndicators(.hidden)
        .navigationTitle("Edit Pin")
        .toolbar {
            toolbarContentView
        }
    }
}

private extension EditMemoryView {
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
}

#Preview {
    @Previewable @State var editMemoryInfo: EditMemoryInfo = .init(title: "", description: "", tags: [], dateTime: .now, publicStatus: true)
    NavigationStack {
        EditMemoryView(
            editMemoryInfo: $editMemoryInfo,
            onSaveClick: {}
        )
    }
}
