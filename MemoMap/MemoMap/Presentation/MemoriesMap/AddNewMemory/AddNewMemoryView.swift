//
//  AddNewMemoryView.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import SwiftUI
import Kingfisher

struct AddNewMemoryScreenModel: Hashable {
    let pin: PinData
}

struct AddNewMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    let addNewMemoryScreenModel: AddNewMemoryScreenModel
    @State private var viewModel: AddNewMemoryViewModel = .init()
    var pin: PinData {
        addNewMemoryScreenModel.pin
    }
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                locationImageView
                locationInfoView
                VStack(alignment: .leading, spacing: 16.0) {
                    Text("Add a memory")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16.0)
                    AddMemoryView(
                        memoryMediaItems: $viewModel.memoryMediaItems,
                        memoryTitle: $viewModel.memoryTitle,
                        memoryDescription: $viewModel.memoryDescription,
                        memoryTags: $viewModel.memoryTags,
                        memoryDateTime: $viewModel.memoryDateTime,
                        isMemoryPublic: $viewModel.isMemoryPublic
                    )
                    saveButtonView
                        .padding(.horizontal, 16.0)
                }
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .toolbar {
            toolbarContentView
        }
        .navigationBarBackButtonHidden()
        .alert(
            isPresented: $viewModel.isSaveMemoryAlertPresented,
            error: viewModel.saveMemoryError
        ){
        }
    }
}

private extension AddNewMemoryView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .imageScale(.large)
                    .fontWeight(.semibold)
            }
        }
    }
    
    @ViewBuilder
    var locationImageView: some View {
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
    }
    
    var locationInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(pin.name)
                .font(.title)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16.0)
    }
    
    var saveButtonView: some View {
        Button {
            Task { await saveMemory() }
        } label: {
            Text("Save")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isSaveMemoryInProgress)
    }
}

private extension AddNewMemoryView {
    func saveMemory() async {
        await viewModel.saveMemory(
            pin: pin,
            onSuccess: {
                dismiss()
            }
        )
    }
}

#Preview {
    NavigationStack {
        AddNewMemoryView(
            addNewMemoryScreenModel: .init(pin: PinData.preview1)
        )
    }
}
