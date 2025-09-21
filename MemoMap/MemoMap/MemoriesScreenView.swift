//
//  MemoriesScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import MapboxMaps

struct MemoriesScreenView: View {
    var body: some View {
        Map {
            
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Memories")
                    .foregroundStyle(.white)
            }
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

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
