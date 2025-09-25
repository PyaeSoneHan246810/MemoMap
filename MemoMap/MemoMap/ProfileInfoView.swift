//
//  ProfileInfoView.swift
//  MemoMap
//
//  Created by Dylan on 25/9/25.
//

import SwiftUI

struct ProfileInfoView: View {
    var body: some View {
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
    ProfileInfoView()
}
