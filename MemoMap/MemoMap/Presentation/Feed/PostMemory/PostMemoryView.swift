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
    @State private var isChooseLocationViewPresented: Bool = false
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
        .navigationDestination(isPresented: $isChooseLocationViewPresented) {
            ChooseLocationView(
                isPresented: $isChooseLocationViewPresented,
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
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .imageScale(.large)
                    .fontWeight(.semibold)
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
            isChooseLocationViewPresented = true
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
