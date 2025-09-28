//
//  AddMemoryView.swift
//  MemoMap
//
//  Created by Dylan on 27/9/25.
//

import SwiftUI
import PhotosUI
import AVKit
import WrappingHStack

struct AddMemoryView: View {
    @Binding var memoryPhotoPickerItem: PhotosPickerItem?
    @Binding var memoryMedia: [MemoryMedia]
    @Binding var memoryTitle: String
    @Binding var memoryDescription: String
    @Binding var memoryTags: [String]
    @Binding var memoryDateTime: Date
    @Binding var isMemoryPublic: Bool
    var option: Option = .selectPublicOrPrivate
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            addMediaView
            Group {
                textFieldsView
                addTagsView
                dateTimePickerView
                switch option {
                case .selectPublicOrPrivate:
                    publicToggleView
                case .selectLocation:
                    selectLocationView
                }
            }
            .padding(.horizontal, 16.0)
        }
    }
}

extension AddMemoryView {
    enum Option {
        case selectPublicOrPrivate
        case selectLocation
    }
}

private extension AddMemoryView {
    var addMediaView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            if !memoryMedia.isEmpty {
                mediaListView
            }
            addMediaPickerView
                .padding(.horizontal, 16.0)
        }
    }
    var mediaListView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(memoryMedia) { media in
                    mediaItemView(media)
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
    func mediaItemView(_ media: MemoryMedia) -> some View {
        Group {
            switch media {
            case .image(_, let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            case .video(_, let movie):
                VideoPlayer(player: AVPlayer(url: movie.url))
            }
        }
        .frame(width: 200.0, height: 200.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .overlay(alignment: .bottomTrailing) {
            Button {
                memoryMedia.removeAll {
                    $0.id == media.id
                }
            } label: {
                Image(systemName: "trash.fill")
                    .padding(4.0)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .contentShape(.circle)
            .padding(12.0)
        }
    }
    var addMediaPickerView: some View {
        PhotosPicker(
            selection: $memoryPhotoPickerItem,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            VStack(alignment: .leading, spacing: 12.0) {
                if memoryMedia.isEmpty {
                    memoryMediaPlaceholderView
                }
                addMediaPickerLabelView
            }
        }
        .onChange(of: memoryPhotoPickerItem) {
            Task {
                guard let item = memoryPhotoPickerItem else { return }
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    memoryMedia.append(.image(id: UUID(), image))
                } else if let video = try? await item.loadTransferable(type: Movie.self) {
                    memoryMedia.append(.video(id: UUID(), video))
                }
                memoryPhotoPickerItem = nil
            }
        }
    }
    var memoryMediaPlaceholderView: some View {
        Image(.imagePlaceholder)
            .resizable()
            .scaledToFit()
            .frame(width: 120.0, height: 120.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
    }
    var addMediaPickerLabelView: some View {
        labelView(title: "Add media", systemImage: "plus")
    }
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
    var selectLocationView: some View {
        NavigationLink {
            
        } label: {
            HStack {
                Label("Choose location", systemImage: "mappin.square")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.plain)
    }
}

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
    NavigationStack {
        AddMemoryView(
            memoryPhotoPickerItem: .constant(nil),
            memoryMedia: .constant([]),
            memoryTitle: .constant(""),
            memoryDescription: .constant(""),
            memoryTags: .constant([]),
            memoryDateTime: .constant(.now),
            isMemoryPublic: .constant(true)
        )
    }
}

