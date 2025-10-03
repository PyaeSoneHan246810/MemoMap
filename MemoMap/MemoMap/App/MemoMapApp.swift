//
//  MemoMapApp.swift
//  MemoMap
//
//  Created by Dylan on 20/9/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MemoMapApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage(AppStorageKeys.colorMode) private var selectedColorMode: ColorMode = .system
    @AppStorage(AppStorageKeys.fontSize) private var selectedFontSize: FontSize = .defaultFontSize
    @AppStorage(AppStorageKeys.language) private var selectedLanguage: Language = .english
    var selectedColorScheme: ColorScheme? {
        switch selectedColorMode {
        case .system:
            nil
        case .light:
            ColorScheme.light
        case .dark:
            ColorScheme.dark
        }
    }
    var body: some Scene {
        WindowGroup {
            StartingView()
                .preferredColorScheme(selectedColorScheme)
                .environment(\.dynamicTypeSize, selectedFontSize.dynamicTypeSize)
                .environment(\.locale, Locale(identifier: selectedLanguage.identifier))
        }
    }
}
