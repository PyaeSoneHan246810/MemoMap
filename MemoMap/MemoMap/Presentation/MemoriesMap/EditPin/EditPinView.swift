//
//  EditPinView.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import SwiftUI

struct EditPinView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var newPinName: String
    @Binding var newPinDescription: String
    @Binding var isErrorAlertPresented: Bool
    let updatePinInfoError: UpdatePinInfoError?
    let isEditInProgress: Bool
    let onSaveClick: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                InputTextFieldView(
                    title: "Location name",
                    placeholder: "Enter name of a location",
                    text: $newPinName,
                    textContentType: .name,
                    autoCorrectionDisabled: true,
                    submitLabel: .next
                )
                InputTextFieldView(
                    title: "Location description",
                    placeholder: "Enter description for a location",
                    text: $newPinDescription,
                    axis: .vertical,
                    lineLimit: 5
                )
                Button("Save", action: onSaveClick)
                    .primaryFilledLargeButtonStyle()
                    .progressButtonStyle(isInProgress: isEditInProgress)
            }
        }
        .disableBouncesVertically()
        .contentMargins(16.0)
        .scrollIndicators(.hidden)
        .navigationTitle("Edit Pin")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(role: .close) {
                    dismiss()
                } 
            }
        }
        .alert(isPresented: $isErrorAlertPresented, error: updatePinInfoError) {}
    }
}

#Preview {
    NavigationStack {
        EditPinView(
            newPinName: .constant(""),
            newPinDescription: .constant(""),
            isErrorAlertPresented: .constant(false),
            updatePinInfoError: nil,
            isEditInProgress: false,
            onSaveClick: {}
        )
    }
}
