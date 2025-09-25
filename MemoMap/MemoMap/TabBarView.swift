//
//  TabBarView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var isVerifyAccountSheetPresented: Bool = true
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
        .sheet(isPresented: $isVerifyAccountSheetPresented) {
            VerifyAccountScreenView(
                isPresented: $isVerifyAccountSheetPresented
            )
        }
    }
}

#Preview {
    TabBarView()
}
