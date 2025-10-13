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
    @State var memoryPhotoPickerItems: [PhotosPickerItem] = []
    @Binding var memoryMediaItems: [MemoryMediaItem]
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
            if !memoryMediaItems.isEmpty {
                mediaItemsView
            }
            addMediaPickerView
                .padding(.horizontal, 16.0)
        }
    }
    var mediaItemsView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(memoryMediaItems) { memoryMediaItem in
                    mediaItemView(memoryMediaItem)
                }
            }
        }
        .disableBouncesHorizontally()
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
    func mediaItemView(_ mediaItem: MemoryMediaItem) -> some View {
        Group {
            switch mediaItem.media {
            case .image(let uiImage):
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            case .video(let movie):
                MemoryVideoView(url: movie.url)
            }
        }
        .frame(width: 200.0, height: 200.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .overlay(alignment: .bottomTrailing) {
            Button {
                memoryMediaItems.removeAll {
                    $0.id == mediaItem.id
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
            selection: $memoryPhotoPickerItems,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            VStack(alignment: .leading, spacing: 12.0) {
                if memoryMediaItems.isEmpty {
                    memoryMediaPlaceholderView
                }
                labelView(title: "Add media", systemImage: "plus")
            }
        }
        .onChange(of: memoryPhotoPickerItems) {
            Task {
                for item in memoryPhotoPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        let memoryMediaItem = MemoryMediaItem(media: .image(image))
                        memoryMediaItems.append(memoryMediaItem)
                    } else if let video = try? await item.loadTransferable(type: Movie.self) {
                        let memoryMediaItem = MemoryMediaItem(media: .video(video))
                        memoryMediaItems.append(memoryMediaItem)
                    }
                }
                memoryPhotoPickerItems.removeAll()
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

