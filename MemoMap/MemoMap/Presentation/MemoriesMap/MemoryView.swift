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
    @State private var viewModel: MemoryViewModel = .init()
    var title: String {
        viewModel.updatedMemory?.title ?? ""
    }
    var tags: [String] {
        viewModel.updatedMemory?.tags ?? []
    }
    var media: [String] {
        viewModel.updatedMemory?.media ?? []
    }
    var body: some View {
        VStack(spacing: 12.0) {
            memoryInfoView
                .padding(.horizontal, 16.0)
            if !media.isEmpty {
                memoryMediasView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16.0)
        .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 12.0))
        .fullScreenCover(isPresented: $viewModel.isEditMemorySheetPresented) {
            editMemoryView
                .interactiveDismissDisabled()
                .onAppear {
                    if let memory = viewModel.updatedMemory {
                        viewModel.editMemoryInfo = .init(
                            title: memory.title,
                            description: memory.description ?? "",
                            tags: memory.tags,
                            dateTime: memory.dateTime,
                            publicStatus: memory.publicStatus
                        )
                    }
                }
        }
        .onAppear {
            viewModel.updatedMemory = memory
        }
    }
}

private extension MemoryView {
    var memoryInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(title)
                .font(.headline)
            if let description = viewModel.updatedMemory?.description {
                Text(description)
                    .font(.subheadline)
            }
            HStack {
                if let dateTime = viewModel.updatedMemory?.dateTime {
                    Text(dateTime.formatted())
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Menu {
                    Button("Edit", systemImage: "pencil") {
                        viewModel.isEditMemorySheetPresented = true
                    }
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
            if !tags.isEmpty {
                MemoryTagsView(
                    tags: tags
                )
            }
        }
    }
    var memoryMediasView: some View {
        MemoryMediasView(
            mediaUrlStrings: media
        )
    }
    var editMemoryView: some View {
        NavigationStack {
            EditMemoryView(
                editMemoryInfo: $viewModel.editMemoryInfo,
                onSaveClick: {
                    if let memory = viewModel.updatedMemory {
                        Task {
                            await viewModel.editMemoryInfo(for: memory.id)
                        }
                    }
                }
            )
        }
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
