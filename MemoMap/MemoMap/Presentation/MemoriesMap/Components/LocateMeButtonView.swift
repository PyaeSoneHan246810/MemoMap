//
//  LocateMeButtonView.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import SwiftUI
import MapboxMaps

struct LocateMeButtonView: View {
    @Binding var viewport: Viewport
    var body: some View {
        Button {
            withViewportAnimation(.default(maxDuration: 1)) {
                if isFocusingUser {
                    viewport = .followPuck(zoom: 16.0, bearing: .heading, pitch: 60.0)
                } else {
                    viewport = .followPuck(zoom: 12.0, bearing: .constant(0), pitch: 0.0)
                }
            }
        } label: {
            Image(systemName: imageName)
                .imageScale(.large)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .controlSize(.large)
    }
    private var isFocusingUser: Bool {
        return viewport.followPuck?.bearing == .constant(0)
    }
    private var isFollowingUser: Bool {
        return viewport.followPuck?.bearing == .heading
    }
    private var imageName: String {
        if isFocusingUser {
           return  "location.fill"
        } else if isFollowingUser {
           return "location.north.line.fill"
        }
        return "location"
    }
}
