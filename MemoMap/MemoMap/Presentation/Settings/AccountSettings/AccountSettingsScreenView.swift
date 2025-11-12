//
//  AccountSettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct AccountSettingsScreenView: View {
    var body: some View {
        List {
            ListItemNavigationLinkView(systemName: "lock", text: "Change password") {
                ChangePasswordScreenView()
            }
            ListItemNavigationLinkView(systemName: "trash", text: "Delete account") {
                DeleteAccountScreenView()
            }
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        AccountSettingsScreenView()
    }
    .environment(appSessionViewModel)
}
