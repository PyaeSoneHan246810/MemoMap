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
    @State private var locationPhotoPickerItem: PhotosPickerItem? = nil
    @State private var locationPhotoImage: Image? = nil
    @State private var locationName: String = ""
    @State private var locationDescription: String = ""
    @State private var memoryPhotoPickerItem: PhotosPickerItem? = nil
    @State private var memoryMedia: [MemoryMedia] = []
    @State private var memoryTitle: String = ""
    @State private var memoryDescription: String = ""
    @State private var memoryTags: [String] = []
    @State private var memoryDateTime: Date = .now
    @State private var isMemoryPublic: Bool = true
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
                            memoryPhotoPickerItem: $memoryPhotoPickerItem,
                            memoryMedia: $memoryMedia,
                            memoryTitle: $memoryTitle,
                            memoryDescription: $memoryDescription,
                            memoryTags: $memoryTags,
                            memoryDateTime: $memoryDateTime,
                            isMemoryPublic: $isMemoryPublic
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
            if let locationPhotoImage {
                locationPhotoImage
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
        PhotosPicker(selection: $locationPhotoPickerItem) {
            Label("Edit Photo", systemImage: "pencil")
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .fontWeight(.semibold)
                .frame(width: 48.0, height: 48.0)
                .glassEffect(.regular.interactive(), in: .circle)
                .tint(.primary)
        }
        .onChange(of: locationPhotoPickerItem) {
            Task {
                if let locationPhotoImage = try? await locationPhotoPickerItem?.loadTransferable(type: Image.self) {
                    self.locationPhotoImage = locationPhotoImage
                }
            }
        }
    }
    @ViewBuilder
    var locationInfoTextFieldsView: some View {
        InputTextFieldView(
            title: "Location name",
            placeholder: "Enter name of a location",
            text: $locationName,
            axis: .horizontal,
            lineLimit: 1
        )
        InputTextFieldView(
            title: "Location description",
            placeholder: "Enter description for a location",
            text: $locationDescription,
            axis: .vertical,
            lineLimit: 4
        )
    }
    var saveButtonView: some View {
        Button {
            
        } label: {
            Text("Save")
        }
        .primaryFilledLargeButtonStyle()
    }
}

#Preview {
    NavigationStack {
        AddNewPinView()
    }
}
