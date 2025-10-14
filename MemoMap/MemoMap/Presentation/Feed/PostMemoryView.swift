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
    @State private var memoryMediaItems: [MemoryMediaItem] = []
    @State private var memoryTitle: String = ""
    @State private var memoryDescription: String = ""
    @State private var memoryTags: [String] = []
    @State private var memoryDateTime: Date = .now
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16.0) {
                AddMemoryView(
                    memoryMediaItems: $memoryMediaItems,
                    memoryTitle: $memoryTitle,
                    memoryDescription: $memoryDescription,
                    memoryTags: $memoryTags,
                    memoryDateTime: $memoryDateTime,
                    isMemoryPublic: .constant(true),
                    publicOrPrivateSelectionEnabled: false
                )
                selectLocationView
                    .padding(.horizontal, 16.0)
                postButtonView
                    .padding(.horizontal, 16.0)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Post a memory")
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
    var selectLocationView: some View {
        NavigationLink {
            
        } label: {
            HStack {
                Label("Choose location", systemImage: "mappin.square")
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .buttonStyle(.plain)
    }
    var postButtonView: some View {
        Button {
            
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
