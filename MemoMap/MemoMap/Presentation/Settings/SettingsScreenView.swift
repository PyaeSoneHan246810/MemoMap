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
            ListItemNavigationLinkView(systemName: "person", text: "Account") {
                AccountSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "sun.min", text: "Apperance") {
                ApperanceSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "globe", text: "Language") {
                LanguageSettingsScreenView()
            }
            ListItemNavigationLinkView(systemName: "info.circle", text: "About") {
                AboutScreenView()
            }
            ListItemNavigationLinkView(systemName: "questionmark.circle", text: "Help") {
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
    }
}

private extension SettingsScreenView {
    var logOutButtonView: some View {
        Button("Log out", systemImage: "rectangle.portrait.and.arrow.right") {
            logOutUser()
        }
        .buttonStyle(.bordered)
        .tint(.red)
        .foregroundStyle(.red)
    }
}

private extension SettingsScreenView {
    func logOutUser() {
        let result = settingsViewModel.logoutUser()
        if case .success = result {
            appSessionViewModel.changeAppSession(.unauthenticated)
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        SettingsScreenView()
    }
    .environment(appSessionViewModel)
}
