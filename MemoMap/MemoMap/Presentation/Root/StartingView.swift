//
//  StartingView.swift
//  MemoMap
//
//  Created by Dylan on 20/9/25.
//

import SwiftUI

struct StartingView: View {
    @State private var appSessionViewModel: AppSessionViewModel = .init()
    var body: some View {
        ZStack {
            switch appSessionViewModel.appSession {
            case .authenticated:
                TabBarView()
                    .transition(.opacity)
            case .unauthenticated:
                AuthNavigationStackView()
                    .transition(.opacity)
            }
        }
        .animation(.spring, value: appSessionViewModel.appSession)
        .environment(appSessionViewModel)
        .onAppear {
            appSessionViewModel.configureAppSession()
        }
    }
}

#Preview {
    StartingView()
}
