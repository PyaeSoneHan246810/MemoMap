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
    @State private var viewport: Viewport = .followPuck(zoom: 12.0)
    @State private var placeTapped: Place? = nil
    var body: some View {
        mapView
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .sheet(item: $placeTapped) {
            addNewPinSheetView(placeTapped: $0)
                .interactiveDismissDisabled()
        }
    }
}

extension MemoriesScreenView {
    struct Place: Identifiable {
        let coordinate: CLLocationCoordinate2D
        var latitude: Double {
            coordinate.latitude
        }
        var longitude: Double {
            coordinate.longitude
        }
        var id: String {
            "\(latitude)&\(longitude)"
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
            viewport: $viewport
        ) {
            Puck2D(bearing: .heading)
                .showsAccuracyRing(true)
            TapInteraction { context in
                placeTapped = .init(coordinate: context.coordinate)
                return true
            }
        }
        .mapStyle(mapStyle)
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
            AddNewPinView()
        }
    }
}

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
