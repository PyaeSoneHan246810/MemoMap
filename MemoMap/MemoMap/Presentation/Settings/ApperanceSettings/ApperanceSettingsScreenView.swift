//
//  ApperanceSettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct ApperanceSettingsScreenView: View {
    @AppStorage(AppStorageKeys.colorMode) private var selectedColorMode: ColorMode = .system
    @AppStorage(AppStorageKeys.fontSize) private var selectedFontSize: FontSize = .defaultFontSize
    var body: some View {
        List {
            colorModePickerView
            fontSizePickerView
        }
        .navigationTitle("Apperance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ApperanceSettingsScreenView {
    var colorModePickerView: some View {
        Picker("Color mode", systemImage: "iphone", selection: $selectedColorMode) {
            ForEach(ColorMode.allCases) { colorMode in
                Text(colorMode.rawValue)
                    .tag(colorMode)
            }
        }
    }
    var fontSizePickerView: some View {
        Picker("Font size", systemImage: "textformat", selection: $selectedFontSize) {
            ForEach(FontSize.allCases) { fontSize in
                Text(fontSize.rawValue)
                    .tag(fontSize)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ApperanceSettingsScreenView()
    }
}
