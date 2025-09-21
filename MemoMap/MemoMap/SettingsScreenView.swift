//
//  SettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct SettingsScreenView: View {
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
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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
            
        }
        .buttonStyle(.bordered)
        .tint(.red)
        .foregroundStyle(.red)
    }
}

#Preview {
    NavigationStack {
        SettingsScreenView()
    }
}
