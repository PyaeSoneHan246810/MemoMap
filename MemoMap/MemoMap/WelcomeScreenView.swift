//
//  WelcomeScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    @AppStorage("isOnboardingCompleted") private var isOnboardingCompleted: Bool = false
    @State private var isOnboardingSheetPresented: Bool = false
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer().frame(height: 136.0)
            infoView
            Spacer().frame(height: 136.0)
            navigationLinksView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16.0)
        .sheet(isPresented: $isOnboardingSheetPresented) {
            onboardingSheetView
        }
        .onAppear {
            isOnboardingSheetPresented = !isOnboardingCompleted
        }
        .onChange(of: isOnboardingCompleted) {
            isOnboardingSheetPresented = !isOnboardingCompleted
        }
    }
}

private extension WelcomeScreenView {
    var infoView: some View {
        VStack(spacing: 16.0) {
            Image(.appLogoCircle)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
            VStack(spacing: 8.0) {
                Text("MemoMap")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Your Map of Memories")
                    .font(.title3)
            }
        }
    }
    var navigationLinksView: some View {
        VStack(spacing: 12.0) {
            NavigationLink {
                LogInScreenView()
            } label: {
                Text("Log in")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
            NavigationLink {
                CreateAccountScreenView()
            } label: {
                Text("Create account")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
        }
    }
    var onboardingSheetView: some View {
        OnboardingView(
            isOnboardingCompleted: $isOnboardingCompleted
        )
        .interactiveDismissDisabled()
    }
}

#Preview {
    NavigationStack {
        WelcomeScreenView()
    }
}
