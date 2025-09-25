//
//  ProfileScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct ProfileScreenView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                VStack(spacing: 0.0) {
                    profilePhotosView
                    buttonSectionView
                    profileInfoView
                }
                .background(Color(uiColor: .systemBackground))
                memoriesView
            }
        }
        .scrollIndicators(.hidden)
        .ignoresSafeArea(.all, edges: .top)
        .background(Color(uiColor: .secondarySystemBackground))
        .toolbar {
            toolbarContentView
        }
    }
}

private extension ProfileScreenView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            NavigationLink {
                SettingsScreenView()
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
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
            editButtonView
        }
        .padding(.top, 16.0)
        .padding(.horizontal, 16.0)
    }
    var editButtonView: some View {
        Button("Edit profile", systemImage: "pencil") {
            
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
    }
    var profileInfoView: some View {
        ProfileInfoView()
            .padding(16.0)
    }
    var memoriesView: some View {
        MemoriesView(
            userProfileScreenModel: .constant(nil)
        )
        .padding(.vertical, 16.0)
    }
}

#Preview {
    NavigationStack {
        ProfileScreenView()
    }
}
