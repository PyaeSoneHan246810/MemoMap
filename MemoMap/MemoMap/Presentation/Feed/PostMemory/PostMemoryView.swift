//
//  PostMemoryView.swift
//  MemoMap
//
//  Created by Dylan on 28/9/25.
//

import SwiftUI
import PhotosUI

struct PostMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PostMemoryViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                AddMemoryView(
                    memoryMediaItems: $viewModel.memoryMediaItems,
                    memoryTitle: $viewModel.memoryTitle,
                    memoryDescription: $viewModel.memoryDescription,
                    memoryTags: $viewModel.memoryTags,
                    memoryDateTime: $viewModel.memoryDateTime,
                    isMemoryPublic: .constant(true)
                )
                selectLocationView
                postButtonView
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Post a memory")
        .navigationDestination(isPresented: $viewModel.isChooseLocationViewPresented) {
            ChooseLocationView(
                isPresented: $viewModel.isChooseLocationViewPresented,
                selectedPin: $viewModel.selectedPin
            )
        }
        .toolbar {
            toolbarContentView
        }
        .alert(
            isPresented: $viewModel.isSaveMemoryAlertPresented,
            error: viewModel.saveMemoryError
        ){
        }
    }
}

private extension PostMemoryView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    @ViewBuilder
    var selectLocationView: some View {
        let labelName = viewModel.selectedPin?.name ?? "Choose saved location"
        HStack {
            Label(labelName, systemImage: "mappin.square")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .contentShape(.rect)
        .onTapGesture {
            viewModel.isChooseLocationViewPresented = true
        }
        .padding(.horizontal, 16.0)
    }
    var postButtonView: some View {
        Button {
            Task {
                await viewModel.postMemory(
                    onSuccess: {
                        dismiss()
                    }
                )
            }
        } label: {
            Text("Post")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isPostMemoryInProgress)
        .disabled(!viewModel.isMemoryTitleValid)
        .padding(.horizontal, 16.0)
    }
}

#Preview {
    NavigationStack {
        PostMemoryView()
    }
}
