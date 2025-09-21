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
                MemoriesScreenView()
            }
            Tab("Feed", systemImage: "photo.stack") {
                FeedScreenView()
            }
            Tab("Profile", systemImage: "person") {
                ProfileScreenView()
            }
        }
    }
}

#Preview {
    TabBarView()
}
