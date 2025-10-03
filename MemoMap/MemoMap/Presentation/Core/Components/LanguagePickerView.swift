//
//  LanguagePickerView.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI

struct LanguagePickerView: View {
    @Binding var selectedLanguage: Language
    var body: some View {
        Picker("App language", systemImage: "translate", selection: $selectedLanguage) {
            ForEach(Language.allCases) { language in
                Text(language.rawValue)
                    .tag(language)
            }
        }
    }
}

#Preview {
    LanguagePickerView(selectedLanguage: .constant(.english))
}
