//
//  ApperanceSettingsScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

enum ColorMode: String, Identifiable, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String {
        rawValue
    }
}

enum FontSize: String, Identifiable, CaseIterable {
    case smallerFontSize = "Smaller"
    case defaultFontSize = "Default"
    case largerFontSize = "Larger"
    var id: String {
        rawValue
    }
    var dynamicTypeSize: DynamicTypeSize {
        switch self {
        case .smallerFontSize:
            .medium
        case .defaultFontSize:
            .large
        case .largerFontSize:
            .xLarge
        }
    }
}

struct ApperanceSettingsScreenView: View {
    @AppStorage("color_mode") private var selectedColorMode: ColorMode = .system
    @AppStorage("font_size") private var selectedFontSize: FontSize = .defaultFontSize
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
