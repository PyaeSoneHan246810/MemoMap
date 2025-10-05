//
//  ProfilePhotoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI
import Kingfisher

struct ProfilePhotoView: View {
    let profilePhoto: String?
    var body: some View {
        Group {
            if let profilePhoto {
                KFImage(URL(string: profilePhoto))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120.0, height: 120.0)
            } else {
                Image(.profilePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120.0, height: 120.0)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .background(Color(uiColor: .systemBackground))
            }
        }
        .clipShape(.circle)
        .overlay {
            Circle().stroke(Color(uiColor: .systemBackground), lineWidth: 2.0)
        }
    }
}

#Preview {
    ProfilePhotoView(
        profilePhoto: nil
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}

#Preview {
    ProfilePhotoView(
        profilePhoto: "https://images.unsplash.com/photo-1758390851311-b009744be513?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
