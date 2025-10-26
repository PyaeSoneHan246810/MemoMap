//
//  EditMemoryMediaView.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct EditMemoryMediaView: View {
    @Environment(\.dismiss) private var dismiss
    let memoryId: String
    let mediaUrlStrings: [String]
    let onEdited: () -> Void
    @State private var viewModel: EditMemoryMediaViewModel = .init()
    var body: some View {
        Group {
            if viewModel.mediaList.isEmpty {
                addNewMediaView
            } else {
                editExistingMediaView
            }
        }
        .navigationTitle("Edit Memory Media")
        .toolbar {
            toolbarContentView
        }
        .overlay {
            if viewModel.isDeleteAllItemsInProgress || viewModel.isDeleteItemInProgress {
                LoadingOverlayView()
            }
        }
        .onAppear {
            viewModel.getMediaList(from: mediaUrlStrings)
        }
        .alert(
            isPresented: $viewModel.isAddingNewItemsAlertPresented,
            error: viewModel.updateMemoryMediaError
        ){
        }
        .alert(
            isPresented: $viewModel.isAddingNewItemAlertPresented,
            error: viewModel.addMemoryMediaError
        ){
        }
        .alert(
            isPresented: $viewModel.isDeleteAllItemsAlertPresented,
            error: viewModel.removeAllMemoryMediaError
        ){
        }
    }
}

private extension EditMemoryMediaView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    var addNewMediaView: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            AddMemoryMediaView(
                memoryMediaItems: $viewModel.newMemoryMediaItems
            )
            saveButtonView
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    var saveButtonView: some View {
        Button("Save") {
            Task {
                await viewModel.addNewMemoryMediaItems(
                    for: memoryId,
                    onSuccess: {
                        dismiss()
                        onEdited()
                    }
                )
            }
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isAddingNewItemsInProgress)
        .padding(.horizontal, 16.0)
    }
    var editExistingMediaView: some View {
        VStack(spacing: 16.0) {
            existingMediaView
            HStack(spacing: 8.0) {
                if viewModel.isAddingNewItemInProgress {
                    ProgressView().controlSize(.large)
                } else {
                    addMediaPhotoPickerView
                }
                deleteAllButtonView
                Spacer()
            }
            .padding(.horizontal, 16.0)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    var addMediaPhotoPickerView: some View {
        PhotosPicker(
            selection: $viewModel.newMemoryMediaPhotoPickerItem,
            matching: .any(of: [.images, .videos]),
            photoLibrary: .shared()
        ) {
            Label("Add media", systemImage: "plus")
                .padding(.horizontal, 8.0)
                .padding(.vertical, 4.0)
                .font(.callout)
                .tint(.primary)
                .background(Color(uiColor: .secondarySystemFill), in: .capsule)
        }
        .onChange(of: viewModel.newMemoryMediaPhotoPickerItem) {
            Task {
                let item = viewModel.newMemoryMediaPhotoPickerItem
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    let memoryMediaItem = MemoryMediaItem(media: .image(image))
                    viewModel.newMemoryMediaItem = memoryMediaItem
                } else if let video = try? await item?.loadTransferable(type: Movie.self) {
                    let memoryMediaItem = MemoryMediaItem(media: .video(video))
                    viewModel.newMemoryMediaItem = memoryMediaItem
                }
            }
        }
        .onChange(of: viewModel.newMemoryMediaItem) {
            Task {
                await viewModel.addNewMemoryMediaItem(
                    for: memoryId,
                    onSuccess: {
                        onEdited()
                    }
                )
            }
        }
    }
    var deleteAllButtonView: some View {
        Button("Delete all", systemImage: "trash") {
            Task {
                await viewModel.deleteAllMemoryMedia(
                    memoryId: memoryId,
                    onSuccess: {
                        onEdited()
                    }
                )
            }
        }
        .destructiveButtonStyle(controlSize: .small)
        .disabled(viewModel.isDeleteAllItemsInProgress)
    }
    @ViewBuilder
    var existingMediaView: some View {
        if viewModel.mediaList.count == 1 {
            if let media = viewModel.mediaList.first {
                singleMediaView(media)
            } else {
                EmptyView()
            }
        } else {
            multiMediaScrollView
        }
    }
    func singleMediaView(_ media: Media) -> some View {
        ZStack(alignment: .bottomTrailing) {
            switch media.type {
            case .image:
                singleMediaImageView(url: media.urlString)
            case .video:
                if let url = URL(string: media.urlString) {
                    singleMediaVideoView(url: url)
                } else {
                    EmptyView()
                }
            }
            deleteIconButtonView {
                deleteMemoryMedia(media)
            }
        }
        .padding(.horizontal, 16.0)
        
    }
    func singleMediaImageView(url: String) -> some View {
        RoundedRectangle(cornerRadius: 12.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(height: 320.0)
            .overlay {
                KFImage(URL(string: url))
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    func singleMediaVideoView(url: URL) -> some View {
        MemoryVideoView(url: url)
            .frame(height: 320.0)
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    var multiMediaScrollView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8.0) {
                ForEach(viewModel.mediaList) { media in
                    ZStack(alignment: .bottomTrailing) {
                        switch media.type {
                        case .image:
                            multiMediaImageView(url: media.urlString)
                        case .video:
                            if let url = URL(string: media.urlString) {
                                multiMediaVideoView(url: url)
                            } else {
                                EmptyView()
                            }
                        }
                        deleteIconButtonView {
                            deleteMemoryMedia(media)
                        }
                    }
                }
            }
        }
        .disableBouncesHorizontally()
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
    func multiMediaImageView(url: String) -> some View {
        RoundedRectangle(cornerRadius: 12.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(width: 200.0, height: 200.0)
            .overlay {
                KFImage(URL(string: url))
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    func multiMediaVideoView(url: URL) -> some View {
        MemoryVideoView(url: url)
        .frame(width: 200.0, height: 200.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    func deleteIconButtonView(onClick: @escaping () -> Void) -> some View {
        Button {
            onClick()
        } label: {
            Image(systemName: "trash.fill")
                .padding(4.0)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .padding(12.0)
    }
}

private extension EditMemoryMediaView {
    func deleteMemoryMedia(_ media: Media) {
        Task {
            await viewModel.deleteMemoryMedia(
                memoryId: memoryId,
                media: media,
                onSuccess: {
                    onEdited()
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        EditMemoryMediaView(
            memoryId: "",
            mediaUrlStrings: [""],
            onEdited: {}
        )
    }
}
