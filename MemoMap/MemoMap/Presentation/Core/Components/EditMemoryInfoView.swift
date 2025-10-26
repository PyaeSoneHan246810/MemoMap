//
//  EditMemoryInfoView.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import SwiftUI
import WrappingHStack

struct EditMemoryInfoView: View {
    @Binding var memoryTitle: String
    @Binding var memoryDescription: String
    @Binding var memoryTags: [String]
    @Binding var memoryDateTime: Date
    @Binding var isMemoryPublic: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            textFieldsView
            addTagsView
            dateTimePickerView
            publicToggleView
        }
    }
}

private extension EditMemoryInfoView {
    var textFieldsView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            TextField(
                text: $memoryTitle,
                prompt: Text("Add a title for your memory...")
                    .font(.headline)
                    .foregroundStyle(.gray),
                axis: .vertical
            ) { }
            .font(.headline)
            .textInputAutocapitalization(.never)
            .submitLabel(.done)
            TextField(
                text: $memoryDescription,
                prompt: Text("Describe your moments")
                    .font(.subheadline)
                    .foregroundStyle(.gray),
                axis: .vertical
            ) { }
            .font(.subheadline)
            .textInputAutocapitalization(.never)
            .submitLabel(.done)
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
    EditMemoryInfoView(
        memoryTitle: .constant(""),
        memoryDescription: .constant(""),
        memoryTags: .constant([]),
        memoryDateTime: .constant(.now),
        isMemoryPublic: .constant(true)
    )
}
