//
//  MemoMapApp.swift
//  MemoMap
//
//  Created by Dylan on 20/9/25.
//

import SwiftUI
import FirebaseCore
import TipKit

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
    init() {
        try? Tips.configure()
    }
    var body: some Scene {
        WindowGroup {
            StartingView()
                .preferredColorScheme(selectedColorScheme)
                .environment(\.dynamicTypeSize, selectedFontSize.dynamicTypeSize)
        }
    }
}
