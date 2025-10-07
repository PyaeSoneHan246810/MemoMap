//
//  AddMemoryTagView.swift
//  MemoMap
//
//  Created by Dylan on 28/9/25.
//

import SwiftUI

struct AddMemoryTagView: View {
    let tag: String
    let isSelected: Bool
    var backgroundColor: Color {
        isSelected ? Color.accentColor : Color(uiColor: .secondarySystemFill)
    }
    var foregroundColor: Color {
        isSelected ? Color.white : Color.primary
    }
    var body: some View {
        Text(tag)
            .font(.callout)
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 12.0)
            .padding(.vertical, 4.0)
            .background(backgroundColor, in: .capsule)
    }
}

#Preview {
    AddMemoryTagView(tag: "Tag 1", isSelected: true)
    AddMemoryTagView(tag: "Tag 2", isSelected: false)
}
