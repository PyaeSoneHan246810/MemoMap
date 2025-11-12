//
//  ErrorView.swift
//  MemoMap
//
//  Created by Dylan on 27/10/25.
//

import SwiftUI

struct ErrorView: View {
    let errorDescription: String
    var body: some View {
        ContentUnavailableView(
            "Something went wrong!",
            systemImage: "exclamationmark.triangle.fill",
            description: Text(errorDescription)
        )
    }
}

#Preview {
    ErrorView(
        errorDescription: "This is error description."
    )
}
