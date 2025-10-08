//
//  ProfileCoverPhotoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI
import Kingfisher

struct ProfileCoverPhotoView: View {
    let coverPhoto: String?
    var body: some View {
        Rectangle()
            .frame(height: 240.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .overlay(alignment: .center) {
                if let coverPhoto {
                    KFImage(URL(string: coverPhoto))
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(.imagePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .frame(width: 100.0, height: 100.0)
                }
            }
            .clipped()
    }
}

#Preview {
    ProfileCoverPhotoView(
        coverPhoto: nil
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}

#Preview {
    ProfileCoverPhotoView(
        coverPhoto: UserProfileData.preview1.coverPhotoUrl
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
