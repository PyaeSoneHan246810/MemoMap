//
//  RecentSearchView.swift
//  MemoMap
//
//  Created by Dylan on 16/10/25.
//

import SwiftUI

struct RecentSearchView: View {
    let searchText: String
    let onRemove: () -> Void
    var body: some View {
        HStack {
            Text(searchText)
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
        onRemove: {}
    )
}
