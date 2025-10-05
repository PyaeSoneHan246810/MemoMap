//
//  ProfileInfoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfileInfoView: View {
    let displayName: String
    let username: String
    let email: String
    let bio: String
    let birthday: String
    let joined: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            VStack(alignment: .leading, spacing: 4.0) {
                Text(displayName)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(username)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(email)
                    .font(.footnote)
                    .tint(.primary)
            }
            Text(bio)
                .font(.subheadline)
            HStack(spacing: 8.0) {
                HStack(spacing: 4.0) {
                    Image(systemName: "birthday.cake.fill")
                        .foregroundStyle(.secondary)
                    Text(birthday)
                }
                HStack(spacing: 4.0) {
                    Text("Joined")
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    Text(joined)
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
    }
}

private extension ProfileInfoView {
    func countInfoView(count: Int, label: String) -> some View {
        HStack(spacing: 4.0) {
            Text(count.description)
                .font(.callout)
                .fontWeight(.medium)
            Text(label)
                .font(.footnote)
        }
    }
}

#Preview {
    ProfileInfoView(
        displayName: "Dylan",
        username: "@dylan2004",
        email: "dylan2004@gmail.com",
        bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        birthday: "June 28, 2001",
        joined: "May 1, 2025"
    )
}
