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
    @AppStorage("color_mode") private var selectedColorMode: ColorMode = .system
    @AppStorage("font_size") private var selectedFontSize: FontSize = .defaultFontSize
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
        }
    }
}
