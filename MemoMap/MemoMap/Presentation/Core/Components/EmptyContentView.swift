//
//  EmptyContentView.swift
//  MemoMap
//
//  Created by Dylan on 13/10/25.
//

import SwiftUI

struct EmptyContentView: View {
    let image: ImageResource
    let title: String
    let description: String
    var body: some View {
        ContentUnavailableView {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
                .foregroundStyle(.secondary)
            Text(title)
        } description: {
            Text(description)
        }
    }
}

#Preview {
    EmptyContentView(
        image: .emptyMemories,
        title: "Title",
        description: "description goes here..."
    )
}
