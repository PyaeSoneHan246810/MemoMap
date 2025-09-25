//
//  ProfilePhotoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfilePhotoView: View {
    var body: some View {
        Image(.profilePlaceholder)
            .resizable()
            .scaledToFit()
            .frame(width: 120.0, height: 120.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .background(Color(uiColor: .systemBackground))
            .clipShape(.circle)
            .overlay {
                Circle().stroke(Color(uiColor: .systemBackground), lineWidth: 1.5)
            }
    }
}

#Preview {
    ProfilePhotoView()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemFill))
}
