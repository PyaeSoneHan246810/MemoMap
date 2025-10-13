//
//  TabBarView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct TabBarView: View {
    @State private var tabBarViewModel: TabBarViewModel = .init()
    @State private var userViewModel: UserViewModel = .init()
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
        .sheet(isPresented: $tabBarViewModel.isVerifyAccountSheetPresented) {
            verifyAccountSheetView
                .interactiveDismissDisabled()
        }
        .task {
            await tabBarViewModel.checkEmailVerificationStatus()
        }
        .onAppear {
            setUpListeners()
        }
        .environment(userViewModel)
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
            MyProfileScreenView()
        }
    }
    var verifyAccountSheetView: some View {
        VerifyAccountView(
            isPresented: $tabBarViewModel.isVerifyAccountSheetPresented
        )
    }
}

private extension TabBarView {
    func setUpListeners() {
        userViewModel.listenUserProfile()
        userViewModel.listenFollowingIds()
        userViewModel.listenFollowers()
        userViewModel.listenFollowings()
        userViewModel.listenFollowersCount()
        userViewModel.listenFollowingsCount()
    }
}

#Preview {
    TabBarView()
}
