//
//  AddPinView.swift
//  MemoMap
//
//  Created by Dylan on 22/10/25.
//

import SwiftUI
import PhotosUI
import MapboxMaps

struct AddPinView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @Binding var locationPhotoImage: UIImage?
    @Binding var locationName: String
    @Binding var locationDescription: String
    @Binding var locationPlace: Place?
    @State private var locationPhotoPickerItem: PhotosPickerItem? = nil
    @State private var viewport: Viewport = .followPuck(zoom: 12.0, bearing: .constant(0.0), pitch: 0.0)
    var clusterOptions: ClusterOptions = .init()
    let onSave: () -> Void
    var body: some View {
        mapView
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
        .sheet(
            item: $locationPlace,
            onDismiss: {
                locationPhotoImage = nil
                locationName = ""
                locationDescription = ""
            }
        ) { _ in
            locationInfoSheetView
                .interactiveDismissDisabled()
        }
    }
}

private extension AddPinView {
    var mapStyle: MapStyle {
        switch colorScheme {
        case .dark:
            MapStyle.standard(lightPreset: .night)
        case .light:
            MapStyle.standard(lightPreset: .day)
        @unknown default:
            MapStyle.standard
        }
    }
    var mapView: some View {
        Map(
            viewport: $viewport
        ) {
            userLocationPuck
            userTapInteraction
        }
        .mapStyle(mapStyle)
        .overlay(alignment: .trailing) {
            LocateMeButtonView(viewport: $viewport)
                .padding(8.0)
        }
    }
    var userLocationPuck: some MapContent {
        Puck2D(bearing: .heading)
            .showsAccuracyRing(true)
    }
    var userTapInteraction: some MapContent {
        TapInteraction { context in
            locationPlace = .init(coordinate: context.coordinate)
            return true
        }
    }
    var locationInfoSheetView: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 20.0) {
                    locationImagePickerView
                    Group {
                        locationInfoTextFieldsView
                        saveButtonView
                    }
                    .padding(.horizontal, 16.0)
                }
            }
            .disableBouncesVertically()
            .scrollIndicators(.hidden)
            .ignoresSafeArea(edges: .top)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(role: .close) {
                        locationPlace = nil
                    }
                }
            }
        }
    }
    var locationImagePickerView: some View {
        ZStack(alignment: .bottomTrailing) {
            if let locationPhotoImage = locationPhotoImage {
                Rectangle()
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 240.0)
                    .overlay {
                        Image(uiImage: locationPhotoImage)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipped()
            } else {
                LocationImagePlaceholderView()
            }
            LocationImagePickerView(
                selection: $locationPhotoPickerItem,
                uiImage: $locationPhotoImage
            )
            .padding(.bottom, 16.0)
            .padding(.trailing, 16.0)
        }
    }
    @ViewBuilder
    var locationInfoTextFieldsView: some View {
        InputTextFieldView(
            localizedTitle: "Location name",
            localizedPlaceholder: "Enter name of a location",
            text: $locationName,
            axis: .horizontal,
            lineLimit: 1
        )
        InputTextFieldView(
            localizedTitle: "Location description",
            localizedPlaceholder: "Enter description for a location",
            text: $locationDescription,
            axis: .vertical,
            lineLimit: 4
        )
    }
    var saveButtonView: some View {
        Button("Save") {
            onSave()
        }
        .primaryFilledLargeButtonStyle()
    }
}

#Preview {
    NavigationStack {
        AddPinView(
            locationPhotoImage: .constant(nil),
            locationName: .constant(""),
            locationDescription: .constant(""),
            locationPlace: .constant(nil),
            onSave: {}
        )
    }
}
