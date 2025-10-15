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
    let pin: PinData
    private var pinId: String {
        pin.id
    }
    private var memories: [MemoryData] {
        viewModel.memories
    }
    private var scrollViewBackgroundColor: Color {
        memories.isEmpty ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground)
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
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
        .task {
            await viewModel.getMemories(for: pinId)
        }
    }
}

private extension SavedPinDetailsView {
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
            if let photoUrl = pin.photoUrl {
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
            LocationImagePickerView(
                selection: .constant(nil), uiImage: .constant(nil)
            )
            .padding(.bottom, 16.0)
            .padding(.trailing, 16.0)
        }
    }
    var locationInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(pin.name)
                .font(.title)
                .fontWeight(.semibold)
            Text(pin.description ?? "No description")
            Button("Edit", systemImage: "pencil") {
                
            }
            .secondaryFilledSmallButtonStyle()
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
            navigateToAddNewMemoryView()
        }
        .primaryFilledSmallButtonStyle()
    }
    @ViewBuilder
    var memoriesView: some View {
        if memories.isEmpty {
            EmptyContentView(
                image: .emptyMemories,
                title: "There is no memories yet!",
                description: "Your memories for this place will appear here once you’ve created one."
            )
        } else {
            LazyVStack(spacing: 16.0) {
                ForEach(memories) { memory in
                    MemoryView(memory: memory)
                }
            }
        }
    }
}

private extension SavedPinDetailsView {
    func navigateToAddNewMemoryView() {
        let addNewMemoryScreenModel: AddNewMemoryScreenModel = .init(
            pin: pin
        )
        self.addNewMemoryScreenModel = addNewMemoryScreenModel
    }
}

#Preview {
    NavigationStack {
        SavedPinDetailsView(
            pin: PinData.preview1
        )
    }
}
