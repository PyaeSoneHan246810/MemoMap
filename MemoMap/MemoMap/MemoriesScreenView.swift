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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
    }
}

private extension MemoriesScreenView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .title) {
            Text("Memories")
                .foregroundStyle(.white)
                .font(.title2)
                .fontWeight(.semibold)
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

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
