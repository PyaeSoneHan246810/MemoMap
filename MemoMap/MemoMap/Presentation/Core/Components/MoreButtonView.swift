//
//  MoreButtonView.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI

struct MoreButtonView: View {
    let onTap: () -> Void
    var body: some View {
        Button {
            onTap()
        } label: {
            Image(systemName: "ellipsis")
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .foregroundStyle(.primary)
        .controlSize(.large)
    }
}

#Preview {
    MoreButtonView {
        
    }
}
