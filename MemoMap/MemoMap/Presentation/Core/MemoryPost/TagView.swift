//
//  TagView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct TagView: View {
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
    TagView(text: "Hiking")
}
