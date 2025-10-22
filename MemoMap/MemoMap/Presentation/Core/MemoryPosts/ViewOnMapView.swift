//
//  ViewOnMapView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ViewOnMapView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    let locationName: String
    let latitude: Double
    let longitude: Double
    private var toolbarbackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    var body: some View {
        PinOnMapView(
            latitude: latitude,
            longitude: longitude
        )
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
            Button(role: .close) {
                dismiss()
            }
        }
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
