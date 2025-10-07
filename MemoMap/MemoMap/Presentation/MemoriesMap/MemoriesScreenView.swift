//
//  MemoriesScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import MapboxMaps

struct MemoriesScreenView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var viewModel: MemoriesViewModel = .init()
    var body: some View {
        mapView
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .sheet(item: $viewModel.placeTapped) {
            addNewPinSheetView(placeTapped: $0)
                .interactiveDismissDisabled()
        }
        .sheet(item: $viewModel.pinTapped) {
            savedPinDetailsSheetView(pinTapped: $0)
                .interactiveDismissDisabled()
        }
        .onAppear {
            viewModel.listenPins()
        }
    }
}

private extension MemoriesScreenView {
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
            viewport: $viewModel.viewport
        ) {
            pinsPointAnnotationGroup
            userLocationPuck
            userTapInteraction
        }
        .mapStyle(mapStyle)
        .overlay(alignment: .trailing) {
            LocateMeButtonView(viewport: $viewModel.viewport)
                .padding(8.0)
        }
    }
    var pinsPointAnnotationGroup: some MapContent {
        PointAnnotationGroup(viewModel.pins) { pin in
            pinPointAnnotation(pin)
        }
        .clusterOptions(viewModel.clusterOptions)
        .onClusterTapGesture { context in
            withViewportAnimation(.default(maxDuration: 1.0)) {
                viewModel.viewport = .camera(
                    center: context.coordinate,
                    zoom: context.expansionZoom
                )
            }
        }
    }
    func pinPointAnnotation(_ pin: PinData) -> PointAnnotation {
        let coordinates = LocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        return PointAnnotation(
            point: Point(coordinates)
        )
        .image(.init(image: UIImage(resource: .pin), name: "pin"))
        .onTapGesture {
            viewModel.pinTapped = pin
        }
    }
    var userLocationPuck: some MapContent {
        Puck2D(bearing: .heading)
            .showsAccuracyRing(true)
    }
    var userTapInteraction: some MapContent {
        TapInteraction { context in
            viewModel.placeTapped = .init(coordinate: context.coordinate)
            return true
        }
    }
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .title) {
            Text("Memories")
                .foregroundStyle(Color(uiColor: .label))
                .font(.title2)
                .fontWeight(.semibold)
        }
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                SettingsScreenView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
    }
    func addNewPinSheetView(placeTapped: Place) -> some View {
        NavigationStack {
            AddNewPinView(place: placeTapped)
        }
    }
    func savedPinDetailsSheetView(pinTapped: PinData) -> some View {
        NavigationStack {
            SavedPinDetailsView(pin: pinTapped)
        }
    }
}

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
