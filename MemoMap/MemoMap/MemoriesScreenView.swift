//
//  MemoriesScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import MapboxMaps

struct MemoriesScreenView: View {
    init() {
        setUpNavigationTitleColor()
    }
    var body: some View {
        Map {
            
        }
        .ignoresSafeArea()
        .navigationTitle("Memories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsScreenView()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
}

private extension MemoriesScreenView {
    func setUpNavigationTitleColor() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
}

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
