//
//  LanguageSettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct LanguageSettingsScreenView: View {
    @AppStorage(AppStorageKeys.language) private var selectedLanguage: Language = .english
    var body: some View {
        List {
            languagePickerView
        }
        .navigationTitle("Languages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension LanguageSettingsScreenView {
    var languagePickerView: some View {
        LanguagePickerView(selectedLanguage: $selectedLanguage)
    }
}

#Preview {
    NavigationStack {
        LanguageSettingsScreenView()
    }
}
