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
                    coverPhotoView
                    editProfileButtonView
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
    var coverPhotoView: some View {
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
            .overlay(alignment: .bottomLeading) {
                profilePhotoView
                    .padding(.leading, 16.0)
                    .offset(y: 60.0)
            }
    }
    var editProfileButtonView: some View {
        HStack {
            Spacer()
            Button("Edit profile", systemImage: "pencil") {
                
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(.top, 16.0)
        .padding(.horizontal, 16.0)
    }
    var profilePhotoView: some View {
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
    var profileInfoView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text("Dylan")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("@dylan2004")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("dylan2004@gmail.com")
                    .font(.footnote)
                    .tint(.primary)
            }
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                .font(.subheadline)
            HStack(spacing: 8.0) {
                HStack(spacing: 4.0) {
                    Image(systemName: "birthday.cake.fill")
                        .foregroundStyle(.secondary)
                    Text("June 28, 2001")
                }
                HStack(spacing: 4.0) {
                    Text("Joined")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Text("May 1, 2025")
                }
            }
            .font(.footnote)
            HStack(spacing: 8.0) {
                countInfoView(count: 10, label: "Followers")
                countInfoView(count: 12, label: "Followings")
                countInfoView(count: 20, label: "Hearts")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16.0)
    }
    func countInfoView(count: Int, label: String) -> some View {
        HStack(spacing: 4.0) {
            Text(count.description)
                .font(.callout)
                .fontWeight(.medium)
            Text(label)
                .font(.footnote)
        }
    }
    var memoriesView: some View {
        LazyVStack(spacing: 16.0) {
            ForEach(1...5, id: \.self) { _ in
                MemoryPostView(memoryPostInfo: MemoryPostView.previewMemoryPostInfo)
            }
        }
        .padding(.vertical, 16.0)
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    NavigationStack {
        ProfileScreenView()
    }
}
