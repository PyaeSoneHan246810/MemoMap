//
//  MemoryView.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI

struct MemoryView: View {
    let memory: MemoryData
    let onDeleteMemory: () -> Void
    var body: some View {
        VStack(spacing: 12.0) {
            memoryInfoView
                .padding(.horizontal, 16.0)
            if !memory.media.isEmpty {
                memoryMediasView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16.0)
        .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 12.0))
    }
}

private extension MemoryView {
    var memoryInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(memory.title)
                .font(.headline)
            if let description = memory.description {
                Text(description)
                    .font(.subheadline)
            }
            HStack {
                Text(memory.dateTime.formatted())
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Menu {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        onDeleteMemory()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .controlSize(.large)
                .buttonStyle(.bordered)
                .buttonBorderShape(.circle)
                .foregroundStyle(.primary)
            }
            if !memory.tags.isEmpty {
                MemoryTagsView(
                    tags: memory.tags
                )
            }
        }
    }
    var memoryMediasView: some View {
        MemoryMediasView(
            mediaUrlStrings: memory.media
        )
    }
}

#Preview {
    MemoryView(
        memory: MemoryData.preview1,
        onDeleteMemory: {}
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
