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
                memoriesNavigationStackView
            }
            Tab("Feed", systemImage: "photo.stack") {
                feedNavigationStackView
            }
            Tab("Profile", systemImage: "person") {
                profileNavigationStackView
            }
        }
        .sheet(isPresented: $isVerifyAccountSheetPresented) {
            verifyAccountSheetView
        }
    }
}

private extension TabBarView {
    var memoriesNavigationStackView: some View {
        NavigationStack {
            MemoriesScreenView()
        }
    }
    var feedNavigationStackView: some View {
        NavigationStack {
            FeedScreenView()
        }
    }
    var profileNavigationStackView: some View {
        NavigationStack {
            ProfileScreenView()
        }
    }
    var verifyAccountSheetView: some View {
        VerifyAccountView(
            isPresented: $isVerifyAccountSheetPresented
        )
    }
}

#Preview {
    TabBarView()
}
