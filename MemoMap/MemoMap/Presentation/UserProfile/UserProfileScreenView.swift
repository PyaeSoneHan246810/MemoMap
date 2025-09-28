//
//  UserProfileScreenView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct UserProfileScreenModel: Hashable {
    let userId: String
}

struct UserProfileScreenView: View {
    let userProfileScreenModel: UserProfileScreenModel
    var isFollowingUser: Bool {
        false
    }
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    profilePhotosView
                    buttonSectionView
                    profileInfoView
                }
                .background(Color(uiColor: .systemBackground))
                if isFollowingUser {
                    memoriesView
                } else {
                    followUserView
                }
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .background(scrollViewBackgroundColor)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

private extension UserProfileScreenView {
    var scrollViewBackgroundColor: Color {
        isFollowingUser ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemBackground)
    }
    var profilePhotosView: some View {
        ProfileCoverPhotoView()
            .overlay(alignment: .bottomLeading) {
                ProfilePhotoView()
                    .padding(.leading, 16.0)
                    .offset(y: 60.0)
            }
    }
    var buttonSectionView: some View {
        HStack {
            Spacer()
            if isFollowingUser {
                followingButtonView
            } else {
                followButtonView
            }
        }
        .padding(.top, 16.0)
        .padding(.horizontal, 16.0)
    }
    var followingButtonView: some View {
        Button("Following") {
            
        }
        .buttonStyle(.bordered)
        .foregroundStyle(.primary)
        .controlSize(.small)
    }
    var followButtonView: some View {
        Button("Follow", systemImage: "person.badge.plus") {
            
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
    }
    var profileInfoView: some View {
        ProfileInfoView()
            .padding(16.0)
    }
    var followUserView: some View {
        VStack(spacing: 16.0) {
            Image(.followUser)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
                .foregroundStyle(.accent)
            Text("Follow the user to see their public memories")
                .multilineTextAlignment(.center)
        }
        .frame(width: 240.0)
    }
    var memoriesView: some View {
        MemoriesView(
            userProfileScreenModel: .constant(nil)
        )
        .padding(.vertical, 16.0)
    }
}

#Preview {
    UserProfileScreenView(
        userProfileScreenModel: .init(userId: "")
    )
}
