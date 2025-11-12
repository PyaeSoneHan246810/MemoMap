//
//  MemoryTagView.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI

struct MemoryTagView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.footnote)
            .padding(.horizontal, 10.0)
            .padding(.vertical, 4.0)
            .background(Color(uiColor: .secondarySystemBackground), in: .capsule)
    }
}

#Preview {
    MemoryTagView(text: "Tag 1")
}
