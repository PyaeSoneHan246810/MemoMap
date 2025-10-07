//
//  LocationImagePlaceholderView.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import SwiftUI

struct LocationImagePlaceholderView: View {
    var body: some View {
        Rectangle()
            .frame(height: 240.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .overlay(alignment: .center) {
                Image(.imagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .frame(width: 100.0, height: 100.0)
            }
    }
}

#Preview {
    LocationImagePlaceholderView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemFill))
}
