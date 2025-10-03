//
//  OnboardingView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import Lottie

struct OnboardingPage: Identifiable {
    let id: UUID = UUID()
    let localizedTitle: String
    let localizedDescription: String
    let animationName: String
}

struct OnboardingView: View {
    let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            localizedTitle: "onboardingTitle1",
            localizedDescription: "onboardingDesc1",
            animationName: "animation_onboarding_1"
        ),
        OnboardingPage(
            localizedTitle: "onboardingTitle2",
            localizedDescription: "onboardingDesc2",
            animationName: "animation_onboarding_2"
        ),
        OnboardingPage(
            localizedTitle: "onboardingTitle3",
            localizedDescription: "onboardingDesc3",
            animationName: "animation_onboarding_3"
        )
    ]
    @AppStorage(AppStorageKeys.language) private var selectedLanguage: Language = .english
    @Binding var isOnboardingCompleted: Bool
    @State private var selectedTabIndex: Int = 0
    private var isFirstTab: Bool {
        selectedTabIndex == 0
    }
    private var isLastTab: Bool {
        selectedTabIndex == onboardingPages.count - 1
    }
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer(minLength: 12.0)
            logoView
            Spacer(minLength: 12.0)
            tabsView
            Spacer(minLength: 8.0)
            buttonsView
            Spacer(minLength: 8.0)
            languagePickerView
        }
    }
}

private extension OnboardingView {
    var logoView: some View {
        Image(.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 140.0)
    }
    var tabsView: some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(onboardingPages.indices, id: \.self) { index in
                let onboardingPage = onboardingPages[index]
                onboardingTabView(onboardingPage)
                    .tag(index)
            }
        }
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .systemGray
        }
    }
    func onboardingTabView(_ onboardingPage: OnboardingPage) -> some View {
        VStack(spacing: 20.0) {
            LottieView(
                animation: .named(onboardingPage.animationName)
            )
            .configure { view in
                view.contentMode = .scaleAspectFit
            }
            .playing(loopMode: .loop)
            .frame(width: 320.0, height: 320.0)
            VStack(spacing: 8.0) {
                Text(LocalizedStringKey(onboardingPage.localizedTitle))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Text(LocalizedStringKey(onboardingPage.localizedDescription))
                    .font(.callout)
                    .fontWeight(.regular)
                    .frame(maxWidth: .infinity)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 16.0)
    }
    @ViewBuilder
    var buttonsView: some View {
        VStack(spacing: 12.0) {
            Group {
                if isLastTab {
                    Button{
                        isOnboardingCompleted = true
                    } label: {
                        Text("Get started")
                    }
                } else {
                    Button{
                        goToNextTab()
                    } label: {
                        Text("Next")
                    }
                }
            }
            .primaryFilledLargeButtonStyle()
            Group {
                if isFirstTab {
                    Button{
                        skipToLastTab()
                    } label: {
                        Text("Skip")
                    }
                } else {
                    Button{
                        goBackToPreviousTab()
                    } label: {
                        Text("Back")
                    }
                }
            }
            .textLargeButtonStyle()
        }
        .padding(.horizontal, 16.0)
    }
    var languagePickerView: some View {
        LanguagePickerView(selectedLanguage: $selectedLanguage)
            .pickerStyle(.navigationLink)
            .padding(.vertical, 8.0)
            .padding(.horizontal, 16.0)
    }
}

private extension OnboardingView {
    func goToNextTab() {
        withAnimation {
            selectedTabIndex = selectedTabIndex + 1
        }
    }
    func skipToLastTab() {
        withAnimation {
            selectedTabIndex = onboardingPages.count - 1
        }
    }
    func goBackToPreviousTab() {
        withAnimation {
            selectedTabIndex = selectedTabIndex - 1
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingView(
            isOnboardingCompleted: .constant(false)
        )
    }
}
