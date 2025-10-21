//
//  PinOnMapView.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import SwiftUI
import MapboxMaps

struct PinOnMapView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    let latitude: Double
    let longitude: Double
    private var pinCoordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    private var initialViewport: Viewport {
        .camera(center: pinCoordinate, zoom: 16.0, pitch: 20.0)
    }
    private var mapStyle: MapStyle {
        switch colorScheme {
        case .dark:
            MapStyle.standard(lightPreset: .night)
        case .light:
            MapStyle.standard(lightPreset: .day)
        @unknown default:
            MapStyle.standard
        }
    }
    var body: some View {
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
    PinOnMapView(
        latitude: PinData.preview1.latitude,
        longitude: PinData.preview1.longitude
    )
}
