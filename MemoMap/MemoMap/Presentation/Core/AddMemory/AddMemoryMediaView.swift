//
//  AddMediaView.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import SwiftUI
import PhotosUI

struct AddMemoryMediaView: View {
    @State var memoryPhotoPickerItems: [PhotosPickerItem] = []
    @Binding var memoryMediaItems: [MemoryMediaItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            if !memoryMediaItems.isEmpty {
                mediaItemsView
            }
            addMediaPickerView
                .padding(.horizontal, 16.0)
        }
    }
}

private extension AddMemoryMediaView {
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
    func labelView(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .padding(.horizontal, 8.0)
            .padding(.vertical, 4.0)
            .font(.callout)
            .tint(.primary)
            .background(Color(uiColor: .secondarySystemFill), in: .capsule)
    }
}

#Preview {
    AddMemoryMediaView(
        memoryMediaItems: .constant([])
    )
}
