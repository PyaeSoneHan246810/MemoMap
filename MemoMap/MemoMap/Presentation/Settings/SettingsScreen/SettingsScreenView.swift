//
//  SettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct SettingsScreenView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel: AppSessionViewModel
    @State private var settingsViewModel: SettingsViewModel = .init()
    var body: some View {
        List {
            ListItemNavigationLinkView(systemName: "person", localizedText: "Account") {
                AccountSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "sun.min", localizedText: "Apperance") {
                ApperanceSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "globe", localizedText: "Languages") {
                LanguageSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "info.circle", localizedText: "About") {
                AboutScreenView()
            }
            ListItemNavigationLinkView(systemName: "questionmark.circle", localizedText: "Help") {
                HelpScreenView()
            }
            logOutButtonView
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .alert(
            "Log out",
            isPresented: $settingsViewModel.isSignOutConfirmationPresented,
            actions: {
                Button("Cancel", role: .cancel) {}
                Button("Log out", role: .destructive) {
                    logOutUser()
                }
            },
            message: {
                Text("Are you sure to log out from the account?")
            }
        )
        .alert(
            isPresented: $settingsViewModel.isSignOutUserAlertPresented,
            error: settingsViewModel.signOutUserError
        ) {}
    }
}

private extension SettingsScreenView {
    var logOutButtonView: some View {
        Button("Log out", systemImage: "rectangle.portrait.and.arrow.right") {
            settingsViewModel.isSignOutConfirmationPresented = true
        }
        .destructiveButtonStyle(controlSize: .regular)
    }
}

private extension SettingsScreenView {
    func logOutUser() {
        settingsViewModel.logoutUser(
            onSuccess: {
                appSessionViewModel.changeAppSession(.unauthenticated)
            }
        )
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        SettingsScreenView()
    }
    .environment(appSessionViewModel)
}
