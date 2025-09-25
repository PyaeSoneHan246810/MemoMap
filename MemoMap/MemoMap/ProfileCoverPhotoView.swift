//
//  ProfileCoverPhotoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfileCoverPhotoView: View {
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
    ProfileCoverPhotoView()
}
