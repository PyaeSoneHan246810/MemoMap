//
//  MemoriesScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import MapboxMaps

struct MemoriesScreenView: View {
    @State private var isAddNewPinSheetPresented: Bool = false
    var body: some View {
        Map {
            
        }
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .sheet(isPresented: $isAddNewPinSheetPresented) {
            addNewPinSheetView
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
    var addNewPinSheetView: some View {
        NavigationStack {
            AddNewPinView()
        }
    }
}

#Preview {
    NavigationStack {
        MemoriesScreenView()
    }
}
