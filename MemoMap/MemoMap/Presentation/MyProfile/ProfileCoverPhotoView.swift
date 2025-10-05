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
        coverPhoto: "https://images.unsplash.com/photo-1743341942781-14f3c65603c4?q=80&w=1742&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
