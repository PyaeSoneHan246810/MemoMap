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
            itemLinkView(
                systemName: "person",
                text: "Account"
            ) {
                AccountSettingsScreenView()
            }
            itemLinkView(
                systemName: "sun.min",
                text: "Apperance"
            ) {
                ApperanceSettingsScreenView()
            }
            itemLinkView(
                systemName: "globe",
                text: "Language"
            ) {
                LanguageSettingsScreenView()
            }
            itemLinkView(
                systemName: "info.circle",
                text: "About"
            ) {
                AboutScreenView()
            }
            itemLinkView(
                systemName: "questionmark.circle",
                text: "Help"
            ) {
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
    func itemLinkView(systemName: String, text: String, @ViewBuilder destinationView: () -> some View) -> some View {
        NavigationLink {
            destinationView()
        } label: {
            HStack {
                HStack(spacing: 12.0) {
                    Image(systemName: systemName)
                        .imageScale(.large)
                    Text(text)
                }
                Spacer()
                Image(systemName: "chevron.forward")
            }
        }
        .navigationLinkIndicatorVisibility(.hidden)
    }
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
