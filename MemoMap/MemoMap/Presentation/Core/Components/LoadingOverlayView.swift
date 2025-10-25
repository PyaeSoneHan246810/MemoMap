//
//  LoadingOverlayView.swift
//  MemoMap
//
//  Created by Dylan on 25/10/25.
//

import SwiftUI

struct LoadingOverlayView: View {
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundStyle(.black.opacity(0.3))
            .overlay {
                ProgressView()
                    .controlSize(.large)
            }
    }
}

#Preview {
    LoadingOverlayView()
}
