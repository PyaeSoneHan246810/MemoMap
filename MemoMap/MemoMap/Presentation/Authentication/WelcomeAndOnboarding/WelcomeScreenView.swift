//
//  WelcomeScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    @AppStorage(AppStorageKeys.isOnboardingCompleted) private var isOnboardingCompleted: Bool = false
    @AppStorage(AppStorageKeys.language) private var selectedLanguage: Language = .english
    private var isOnboardingSheetPresented: Binding<Bool> {
        Binding {
            !isOnboardingCompleted
        } set: { newValue in
            isOnboardingCompleted = !newValue
        }
    }
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer().frame(height: 136.0)
            infoView
            Spacer().frame(height: 136.0)
            navigationLinksView
            Spacer().frame(height: 12.0)
            languagePickerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16.0)
        .sheet(isPresented: isOnboardingSheetPresented) {
            onboardingSheetView
                .interactiveDismissDisabled()
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
            }
            .primaryFilledLargeButtonStyle()
            NavigationLink {
                CreateAccountScreenView()
            } label: {
                Text("Create account")
            }
            .secondaryFilledLargeButtonStyle()
        }
    }
    var languagePickerView: some View {
        LanguagePickerView(selectedLanguage: $selectedLanguage)
            .pickerStyle(.navigationLink)
            .padding(.vertical, 8.0)
    }
    var onboardingSheetView: some View {
        NavigationStack {
            OnboardingView(
                isOnboardingCompleted: $isOnboardingCompleted
            )
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        WelcomeScreenView()
    }
    .environment(appSessionViewModel)
}
