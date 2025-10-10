//
//  ViewOnMapView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI
import MapboxMaps

struct ViewOnMapView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    let locationName: String
    let latitude: Double
    let longitude: Double
    private var pinCoordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    private var initialViewport: Viewport {
        .camera(center: pinCoordinate, zoom: 16.0, pitch: 20.0)
    }
    private var toolbarbackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    var body: some View {
        mapView
        .ignoresSafeArea()
        .navigationTitle(locationName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.visible, for: .navigationBar)
        .toolbarBackground(toolbarbackground, for: .navigationBar)
        .toolbar {
            toolbarContentView
        }
    }
}

private extension ViewOnMapView {
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
        Map(initialViewport: initialViewport) {
            pinPointAnnotation
            userLocationPuck
        }
        .mapStyle(mapStyle)
    }
    var pinPointAnnotation: some MapContent {
        PointAnnotation(
            point: Point(pinCoordinate)
        )
        .image(.init(image: UIImage(resource: .pin), name: "pin"))
    }
    var userLocationPuck: some MapContent {
        Puck2D(bearing: .heading)
            .showsAccuracyRing(true)
    }
}

#Preview {
    NavigationStack {
        ViewOnMapView(
            locationName: "Central World",
            latitude: 13.7465,
            longitude: 100.5391,
        )
    }
}
