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
        profilePhoto: UserProfileData.preview1.profilePhotoUrl
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
