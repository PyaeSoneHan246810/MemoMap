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
    let onSaveClick: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                InputTextFieldView(
                    localizedTitle: "Location name",
                    localizedPlaceholder: "Enter name of a location",
                    text: $newPinName,
                    axis: .horizontal,
                    lineLimit: 1
                )
                InputTextFieldView(
                    localizedTitle: "Location description",
                    localizedPlaceholder: "Enter description for a location",
                    text: $newPinDescription,
                    axis: .vertical,
                    lineLimit: 4
                )
                Button("Save", action: onSaveClick)
                    .primaryFilledLargeButtonStyle()
            }
        }
        .disableBouncesVertically()
        .contentMargins(16.0)
        .scrollIndicators(.hidden)
        .navigationTitle("Edit Pin")
        .toolbar {
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
    }
}

#Preview {
    NavigationStack {
        EditPinView(
            newPinName: .constant(""),
            newPinDescription: .constant(""),
            onSaveClick: {}
        )
    }
}
