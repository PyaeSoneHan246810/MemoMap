//
//  TabBarView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            Tab("Memories", systemImage: "map") {
                NavigationStack {
                    MemoriesScreenView()
                }
            }
            Tab("Feed", systemImage: "photo.stack") {
                NavigationStack {
                    FeedScreenView()
                }
            }
            Tab("Profile", systemImage: "person") {
                NavigationStack {
                    ProfileScreenView()
                }
            }
        }
    }
}

#Preview {
    TabBarView()
}
