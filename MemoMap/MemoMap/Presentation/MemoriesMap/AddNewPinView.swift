//
//  AddNewPinView.swift
//  MemoMap
//
//  Created by Dylan on 27/9/25.
//

import SwiftUI
import PhotosUI

struct AddNewPinView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddNewPinViewModel = .init()
    let place: Place
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                locationImageView
                VStack(spacing: 20.0) {
                    locationInfoTextFieldsView
                        .padding(.horizontal, 16.0)
                    VStack(alignment: .leading, spacing: 20.0) {
                        Text("Add a memory")
                            .font(.headline)
                            .padding(.horizontal, 16.0)
                        AddMemoryView(
                            memoryPhotoPickerItem: $viewModel.memoryPhotoPickerItem,
                            memoryMedia: $viewModel.memoryMedia,
                            memoryTitle: $viewModel.memoryTitle,
                            memoryDescription: $viewModel.memoryDescription,
                            memoryTags: $viewModel.memoryTags,
                            memoryDateTime: $viewModel.memoryDateTime,
                            isMemoryPublic: $viewModel.isMemoryPublic
                        )
                    }
                    saveButtonView
                        .padding(.horizontal, 16.0)
                }
                .padding(.vertical, 16.0)
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            toolbarContentView
        }
    }
}

private extension AddNewPinView {
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
    var locationImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let locationPhotoImage = viewModel.locationPhotoImage {
                Image(uiImage: locationPhotoImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 240.0)
                    .clipped()
            } else {
                locationImagePlaceholderView
            }
            locationImagePickerView
                .padding(.bottom, 16.0)
                .padding(.trailing, 16.0)
        }
    }
    var locationImagePlaceholderView: some View {
        Rectangle()
            .frame(height: 240.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .overlay(alignment: .center) {
                Image(.imagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .frame(width: 100.0, height: 100.0)
            }
    }
    var locationImagePickerView: some View {
        PhotosPicker(selection: $viewModel.locationPhotoPickerItem) {
            Label("Edit Photo", systemImage: "pencil")
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .fontWeight(.semibold)
                .frame(width: 48.0, height: 48.0)
                .glassEffect(.regular.interactive(), in: .circle)
                .tint(.primary)
        }
        .onChange(of: viewModel.locationPhotoPickerItem) {
            Task {
                if let locationPhotoData = try? await viewModel.locationPhotoPickerItem?.loadTransferable(type: Data.self) {
                    let locationPhotoImage = UIImage(data: locationPhotoData)
                    self.viewModel.locationPhotoImage = locationPhotoImage
                }
            }
        }
    }
    @ViewBuilder
    var locationInfoTextFieldsView: some View {
        InputTextFieldView(
            localizedTitle: "Location name",
            localizedPlaceholder: "Enter name of a location",
            text: $viewModel.locationName,
            axis: .horizontal,
            lineLimit: 1
        )
        InputTextFieldView(
            localizedTitle: "Location description",
            localizedPlaceholder: "Enter description for a location",
            text: $viewModel.locationDescription,
            axis: .vertical,
            lineLimit: 4
        )
    }
    var saveButtonView: some View {
        Button {
            Task { await saveNewPin() }
        } label: {
            Text("Save")
        }
        .primaryFilledLargeButtonStyle()
    }
}

private extension AddNewPinView {
    func saveNewPin() async {
        let result = await viewModel.saveNewPin(
            latitude: place.latitude,
            longitude: place.longitude
        )
        if case .success = result {
            dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        AddNewPinView(
            place: .init(coordinate: .init(latitude: 0.0, longitude: 0.0))
        )
    }
}
