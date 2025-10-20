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
    var publicOrPrivateSelectionEnabled: Bool = true
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

private extension AddMemoryView {
    var textFieldsView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            TextField(
                text: $memoryTitle,
                prompt: Text("Add a title for your memory...").font(.headline).foregroundStyle(.gray)
            ) { }
            .font(.headline)
            TextField(
                text: $memoryDescription,
                prompt: Text("Describe your moments").font(.subheadline).foregroundStyle(.gray)
            ) { }
            .font(.subheadline)
        }
    }
    var addTagsView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            if !memoryTags.isEmpty {
                selectedTagsView
            }
            NavigationLink {
                MemoryTagsSelectionView(
                    tags: StaticData.tags,
                    selectedTags: $memoryTags
                )
            } label: {
                labelView(title: "Add tags", systemImage: "plus")
            }
        }
    }
    var selectedTagsView: some View {
        WrappingHStack(alignment: .leading, horizontalSpacing: 4.0, verticalSpacing: 4.0) {
            ForEach(memoryTags, id: \.self) { tag in
                selectedTagView(
                    tag,
                    onRemove: {
                        withAnimation {
                            memoryTags.removeAll {
                                $0 == tag
                            }
                        }
                    }
                )
            }
        }
    }
    func selectedTagView(_ tag: String, onRemove: @escaping () -> Void) -> some View {
        HStack(spacing: 4.0) {
            Text(tag)
                .font(.callout)
            Image(systemName: "xmark")
                .imageScale(.small)
                .onTapGesture {
                    onRemove()
                }
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 12.0)
        .padding(.vertical, 4.0)
        .background(Color(uiColor: .secondarySystemFill), in: .capsule)
    }
    func labelView(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .padding(.horizontal, 8.0)
            .padding(.vertical, 4.0)
            .font(.callout)
            .tint(.primary)
            .background(Color(uiColor: .secondarySystemFill), in: .capsule)
    }
    var dateTimePickerView: some View {
        DatePicker(
            "Select date and time",
            selection: $memoryDateTime
        )
        .labelsHidden()
    }
    var publicToggleView: some View {
        Toggle(isOn: $isMemoryPublic) {
            Text("Share with followers")
        }
        .tint(.accent)
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

