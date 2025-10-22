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
            VStack(spacing: 16.0) {
                AddMemoryView(
                    memoryMediaItems: $viewModel.memoryMediaItems,
                    memoryTitle: $viewModel.memoryTitle,
                    memoryDescription: $viewModel.memoryDescription,
                    memoryTags: $viewModel.memoryTags,
                    memoryDateTime: $viewModel.memoryDateTime,
                    isMemoryPublic: .constant(true)
                )
                selectLocationView
                    .padding(.horizontal, 16.0)
                postButtonView
                    .padding(.horizontal, 16.0)
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
    }
    var postButtonView: some View {
        Button {
            Task {
                await viewModel.postMemory(
                    onComplete: {
                        dismiss()
                    }
                )
            }
        } label: {
            Text("Post")
        }
        .primaryFilledLargeButtonStyle()
    }
}

#Preview {
    NavigationStack {
        PostMemoryView()
    }
}
