//
//  SavedPinDetailsView.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import SwiftUI
import Kingfisher

struct SavedPinDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SavedPinDetailsViewModel = .init()
    @State private var addNewMemoryScreenModel: AddNewMemoryScreenModel? = nil
    let pinId: String
    private var pin: PinData? {
        viewModel.pin
    }
    private var memories: [MemoryData] {
        viewModel.memories
    }
    private var scrollViewBackgroundColor: Color {
        memories.isEmpty ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground)
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                locationImageView
                locationInfoView
                memoriesSectionView
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .background(scrollViewBackgroundColor)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            toolbarContentView
        }
        .navigationDestination(item: $addNewMemoryScreenModel) {
            AddNewMemoryView(addNewMemoryScreenModel: $0)
        }
        .overlay {
            if viewModel.isDeletePinInProgress || viewModel.isDeleteMemoryInProgress {
                LoadingOverlayView()
            }
        }
        .sheet(isPresented: $viewModel.isEditPinSheetPresented) {
            editPinSheetView
                .presentationDetents([.fraction(0.70)])
                .interactiveDismissDisabled()
                .onAppear {
                    if let pin {
                        viewModel.newPinName = pin.name
                        viewModel.newPinDescription = pin.description ?? ""
                    }
                }
        }
        .task {
            await viewModel.getPin(for: pinId)
            await viewModel.getMemories(for: pinId)
        }
        .alert(
            "Delete pin",
            isPresented: $viewModel.isDeletePinConfirmationPresented,
            actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deletePin(
                            for: pinId,
                            onSuccess: {
                                dismiss()
                            }
                        )
                    }
                }
            },
            message: {
                Text("Are you sure to delete this location and all of the memories?")
            }
        )
        .alert(
            isPresented: $viewModel.isEditPinPhotoAlertPresented,
            error: viewModel.editPinPhotoError
        ){
        }
        .alert(
            isPresented: $viewModel.isDeletePinAlertPresented,
            error: viewModel.deletePinError
        ){
        }
        .alert(
            isPresented: $viewModel.isDeleteMemoryAlertPresented,
            error: viewModel.deleteMemoryError
        ){
        }
    }
}

private extension SavedPinDetailsView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    var locationImageView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let photoUrl = pin?.photoUrl {
                Rectangle()
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 240.0)
                    .overlay {
                        KFImage(URL(string: photoUrl))
                            .resizable()
                            .scaledToFill()
                    }
                    .clipped()
            } else {
                LocationImagePlaceholderView()
            }
            ZStack {
                if viewModel.isEditPinPhotoInProgress {
                    ProgressView().controlSize(.large)
                } else {
                    LocationImagePickerView(
                        selection: $viewModel.newPinPhotoPickerItem,
                        uiImage: $viewModel.newPinPhoto
                    )
                    .onChange(of: viewModel.newPinPhoto) {
                        Task { await viewModel.editPinPhoto(for: pinId) }
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.isEditPinPhotoInProgress)
            .padding(.bottom, 16.0)
            .padding(.trailing, 16.0)
        }
    }
    var locationInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(pin?.name ?? "Placeholder")
                .font(.title)
                .fontWeight(.semibold)
                .redacted(reason: pin == nil ? .placeholder : [])
            if let pin {
                Text(pin.description ?? "No description.")
                HStack(spacing: 12.0) {
                    Button("Edit", systemImage: "pencil") {
                        viewModel.isEditPinSheetPresented = true
                    }
                    .secondaryFilledSmallButtonStyle()
                    Button("Delete", systemImage: "trash") {
                        viewModel.isDeletePinConfirmationPresented = true
                    }
                    .destructiveButtonStyle(controlSize: .small)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16.0)
        .background(Color(uiColor: .systemBackground))
    }
    var memoriesSectionView: some View {
        VStack(alignment: .leading, spacing: 16.0) {
            HStack {
                memoriesHeaderView
                Spacer()
                addMemoryButtonView
            }
            .padding(.horizontal, 16.0)
            memoriesView
        }
        .padding(.vertical, 16.0)
    }
    var memoriesHeaderView: some View {
        Text("Memories")
            .font(.title3)
            .fontWeight(.semibold)
    }
    var addMemoryButtonView: some View {
        Button("Add", systemImage: "plus") {
            if let pin {
                navigateToAddNewMemoryView(pin: pin)
            }
        }
        .primaryFilledSmallButtonStyle()
    }
    @ViewBuilder
    var memoriesView: some View {
        if memories.isEmpty {
            EmptyContentView(
                image: .emptyData,
                title: "There is no memories yet!",
                description: "Your memories for this place will appear here once you’ve created one."
            )
        } else {
            LazyVStack(spacing: 16.0) {
                ForEach(memories) { memory in
                    MemoryView(
                        memory: memory,
                        onDeleteMemory: {
                            Task {
                                await viewModel.deleteMemory(for: memory.id)
                            }
                        }
                    )
                }
            }
        }
    }
    var editPinSheetView: some View {
        NavigationStack {
            EditPinView(
                newPinName: $viewModel.newPinName,
                newPinDescription: $viewModel.newPinDescription,
                isErrorAlertPresented: $viewModel.isEditPinInfoAlertPresented,
                updatePinInfoError: viewModel.updatePinInfoError,
                isEditInProgress: viewModel.isEditPinInfoInProgress,
                onSaveClick: {
                    Task {
                        await viewModel.editPinInfo(for: pinId)
                    }
                }
            )
        }
    }
}

private extension SavedPinDetailsView {
    func navigateToAddNewMemoryView(pin: PinData) {
        let addNewMemoryScreenModel: AddNewMemoryScreenModel = .init(
            pin: pin
        )
        self.addNewMemoryScreenModel = addNewMemoryScreenModel
    }
}

#Preview {
    NavigationStack {
        SavedPinDetailsView(
            pinId: PinData.preview1.id
        )
    }
}
