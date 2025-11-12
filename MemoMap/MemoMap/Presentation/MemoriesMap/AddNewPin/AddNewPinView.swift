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
            LazyVStack(spacing: 0.0) {
                locationImagePickerView
                VStack(spacing: 20.0) {
                    locationInfoTextFieldsView
                    addMemoryView
                    saveButtonView
                }
                .padding(.vertical, 16.0)
                .animation(.smooth, value: viewModel.addMemory)
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            toolbarContentView
        }
        .alert(
            isPresented: $viewModel.isSaveNewPinAlertPresented,
            error: viewModel.saveNewPinError
        ){
        }
    }
}

private extension AddNewPinView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    var locationImagePickerView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let locationPhotoImage = viewModel.locationPhotoImage {
                Rectangle()
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 240.0)
                    .overlay {
                        Image(uiImage: locationPhotoImage)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipped()
            } else {
                LocationImagePlaceholderView()
            }
            LocationImagePickerView(
                selection: $viewModel.locationPhotoPickerItem,
                uiImage: $viewModel.locationPhotoImage
            )
            .padding(.bottom, 16.0)
            .padding(.trailing, 16.0)
        }
    }
    var locationInfoTextFieldsView: some View {
        Group {
            VStack(alignment: .leading, spacing: 8.0) {
                InputTextFieldView(
                    title: "Location name *",
                    placeholder: "Enter name of a location",
                    text: $viewModel.locationName,
                    textContentType: .name,
                    autoCorrectionDisabled: true,
                    submitLabel: .next
                )
            }
            InputTextFieldView(
                title: "Location description",
                placeholder: "Enter description for a location",
                text: $viewModel.locationDescription,
                submitLabel: .next,
                axis: .vertical,
                lineLimit: 5
            )
        }
        .padding(.horizontal, 16.0)
    }
    @ViewBuilder
    var addMemoryView: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            HStack {
                Text("Add a memory")
                    .font(.headline)
                Spacer()
                Toggle(isOn: $viewModel.addMemory) {
                }
                .tint(.accent)
            }
            .padding(.horizontal, 16.0)
            if viewModel.addMemory {
                AddMemoryView(
                    memoryMediaItems: $viewModel.memoryMediaItems,
                    memoryTitle: $viewModel.memoryTitle,
                    memoryDescription: $viewModel.memoryDescription,
                    memoryTags: $viewModel.memoryTags,
                    memoryDateTime: $viewModel.memoryDateTime,
                    isMemoryPublic: $viewModel.isMemoryPublic
                )
            }
        }
    }
    var saveButtonView: some View {
        Button {
            Task { await saveNewPin() }
        } label: {
            Text("Save")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isSaveNewPinInProgress)
        .disabled(!viewModel.isSavePinValid)
        .padding(.horizontal, 16.0)
    }
}

private extension AddNewPinView {
    func saveNewPin() async {
        await viewModel.saveNewPin(
            latitude: place.latitude,
            longitude: place.longitude,
            onSuccess: {
                dismiss()
            }
        )
    }
}

#Preview {
    NavigationStack {
        AddNewPinView(
            place: .init(coordinate: .init(latitude: 0.0, longitude: 0.0))
        )
    }
}
