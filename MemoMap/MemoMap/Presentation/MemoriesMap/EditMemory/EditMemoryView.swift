//
//  EditMemoryInfoView.swift
//  MemoMap
//
//  Created by Dylan on 19/10/25.
//

import SwiftUI

struct EditMemoryInfo {
    var title: String
    var description: String
    var tags: [String]
    var dateTime: Date
    var publicStatus: Bool
}

struct EditMemoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var editMemoryInfo: EditMemoryInfo
    @Binding var isErrorAlertPresented: Bool
    let updateMemoryInfoError: UpdateMemoryInfoError?
    let isEditInProgress: Bool
    let isSaveButtonDisable: Bool
    let onSaveClick: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20.0) {
                EditMemoryInfoView(
                    memoryTitle: $editMemoryInfo.title,
                    memoryDescription: $editMemoryInfo.description,
                    memoryTags: $editMemoryInfo.tags,
                    memoryDateTime: $editMemoryInfo.dateTime,
                    isMemoryPublic: $editMemoryInfo.publicStatus
                )
                Button("Save", action: onSaveClick)
                    .primaryFilledLargeButtonStyle()
                    .progressButtonStyle(isInProgress: isEditInProgress)
                    .disabled(isSaveButtonDisable)
            }
        }
        .disableBouncesVertically()
        .contentMargins(16.0)
        .scrollIndicators(.hidden)
        .navigationTitle("Edit Memory Info")
        .toolbar {
            toolbarContentView
        }
        .alert(isPresented: $isErrorAlertPresented, error: updateMemoryInfoError) {}
    }
}

private extension EditMemoryView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable @State var editMemoryInfo: EditMemoryInfo = .init(title: "", description: "", tags: [], dateTime: .now, publicStatus: true)
    NavigationStack {
        EditMemoryView(
            editMemoryInfo: $editMemoryInfo,
            isErrorAlertPresented: .constant(false),
            updateMemoryInfoError: nil,
            isEditInProgress: false,
            isSaveButtonDisable: false,
            onSaveClick: {}
        )
    }
}
