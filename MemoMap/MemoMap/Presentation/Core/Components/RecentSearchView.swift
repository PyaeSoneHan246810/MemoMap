//
//  RecentSearchView.swift
//  MemoMap
//
//  Created by Dylan on 16/10/25.
//

import SwiftUI

struct RecentSearchView: View {
    let searchText: String
    let onTextTapped: () -> Void
    let onRemove: () -> Void
    var body: some View {
        HStack {
            Text(searchText)
                .onTapGesture(perform: onTextTapped)
            Spacer()
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark")
            }
            .foregroundStyle(.primary)
            .controlSize(.small)
        }
    }
}

#Preview {
    RecentSearchView(
        searchText: "Recent Search",
        onTextTapped: {},
        onRemove: {}
    )
}
