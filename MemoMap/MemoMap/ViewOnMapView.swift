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
    private var toolbarbackground: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    var body: some View {
        Map {
            
        }
        .ignoresSafeArea()
        .navigationTitle("Location name")
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
}

#Preview {
    NavigationStack {
        ViewOnMapView()
    }
}
