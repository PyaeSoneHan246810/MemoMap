//
//  SavedPinDetailsView.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import SwiftUI
import Kingfisher
import SwiftUIIntrospect

struct SavedPinDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SavedPinDetailsViewModel = .init()
    let pin: PinData
    private var scrollViewBackgroundColor: Color {
        viewModel.memories.isEmpty ? Color(uiColor: .systemBackground) : Color(uiColor: .secondarySystemBackground)
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                locationImageView
                locationInfoView
                memoriesSectionView
            }
        }
        .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
            scrollView.bouncesVertically = false
        }
        .scrollIndicators(.hidden)
        .background(scrollViewBackgroundColor)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            toolbarContentView
        }
        .onAppear {
            let pinId = pin.id
            viewModel.listenMemories(for: pinId)
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
            Text(pin.description ?? "No description...")
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
            if !viewModel.memories.isEmpty {
                memoriesView
            }
        }
        .padding(16.0)
    }
    var memoriesHeaderView: some View {
        Text("Memories")
            .font(.title3)
            .fontWeight(.semibold)
    }
    var addMemoryButtonView: some View {
        Button("Add", systemImage: "plus") {
            
        }
        .primaryFilledSmallButtonStyle()
    }
    var memoriesView: some View {
        LazyVStack(spacing: 16.0) {
            ForEach(viewModel.memories) { memory in
                MemoryView(memory: memory)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SavedPinDetailsView(
            pin: PinData.preview2
        )
    }
}
