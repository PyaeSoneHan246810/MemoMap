//
//  TabBarView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct TabBarView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel: AppSessionViewModel
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
        .overlay {
            if tabBarViewModel.isReloadUserInProgress {
                LoadingOverlayView()
            }
        }
        .task {
            await tabBarViewModel.checkEmailVerificationStatus()
        }
        .onAppear {
            setUpListeners()
        }
        .sheet(isPresented: $tabBarViewModel.isVerifyAccountSheetPresented) {
            verifyAccountSheetView
                .interactiveDismissDisabled()
        }
        .alert(
            isPresented: $tabBarViewModel.isReloadUserAlertPresented,
            error: tabBarViewModel.reloadUserError
        ) {
            if case .userNotFound = tabBarViewModel.reloadUserError {
                logOutAlertButtonView
            } else {
                retryAlertButtonView
            }
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
    var logOutAlertButtonView: some View {
        Button("Log out") {
            tabBarViewModel.logOutUser(
                onSuccess: {
                    appSessionViewModel.changeAppSession(.unauthenticated)
                }
            )
        }
    }
    var retryAlertButtonView: some View {
        Button("Retry") {
            Task {
                await tabBarViewModel.checkEmailVerificationStatus()
            }
        }
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
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    TabBarView()
        .environment(appSessionViewModel)
}
