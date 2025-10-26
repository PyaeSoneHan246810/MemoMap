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
                        .padding(.horizontal, 16.0)
                    VStack(alignment: .leading, spacing: 20.0) {
                        Text("Add a memory")
                            .font(.headline)
                            .padding(.horizontal, 16.0)
                        AddMemoryView(
                            memoryMediaItems: $viewModel.memoryMediaItems,
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
    @ViewBuilder
    var locationInfoTextFieldsView: some View {
        InputTextFieldView(
            localizedTitle: "Location name",
            localizedPlaceholder: "Enter name of a location",
            text: $viewModel.locationName,
            textContentType: .name,
            autoCorrectionDisabled: true,
            submitLabel: .next
        )
        InputTextFieldView(
            localizedTitle: "Location description",
            localizedPlaceholder: "Enter description for a location",
            text: $viewModel.locationDescription,
            submitLabel: .next,
            axis: .vertical,
            lineLimit: 5
        )
    }
    var saveButtonView: some View {
        Button {
            Task { await saveNewPin() }
        } label: {
            Text("Save")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isSaveNewPinInProgress)
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
