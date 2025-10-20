//
//  LocationImagePickerView.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import SwiftUI
import PhotosUI

struct LocationImagePickerView: View {
    @Binding var selection: PhotosPickerItem?
    @Binding var uiImage: UIImage?
    var body: some View {
        PhotosPicker(
            selection: $selection,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Label("Edit Photo", systemImage: "pencil")
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .fontWeight(.semibold)
                .frame(width: 48.0, height: 48.0)
                .glassEffect(.regular.interactive(), in: .circle)
                .tint(.primary)
        }
        .onChange(of: selection) {
            Task {
                if let photoData = try? await selection?.loadTransferable(type: Data.self) {
                    let photoUIImage = UIImage(data: photoData)
                    uiImage = photoUIImage
                }
            }
        }
    }
}

#Preview {
    LocationImagePickerView(
        selection: .constant(nil),
        uiImage: .constant(nil)
    )
}
