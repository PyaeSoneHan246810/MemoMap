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
    let title: String
    let description: String
    let animationName: String
}

struct OnboardingView: View {
    let onboardingPages: [OnboardingPage] = [
        OnboardingPage(
            title: "Capture Memories on the Map",
            description: "Pin places you’ve visited and attach your memories",
            animationName: "animation_onboarding_1"
        ),
        OnboardingPage(
            title: "Relive Your Journeys",
            description: "Rediscover the places you’ve loved and the memories you’ve made there.",
            animationName: "animation_onboarding_2"
        ),
        OnboardingPage(
            title: "Share & Connect",
            description: "Choose what stays private and what goes public. Follow friends and explore their shared memories.",
            animationName: "animation_onboarding_3"
        )
    ]
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
            Spacer(minLength: 20.0)
            logoView
            Spacer(minLength: 20.0)
            tabsView
            Spacer(minLength: 12.0)
            buttonsView
            Spacer(minLength: 20.0)
        }
    }
}

private extension OnboardingView {
    var logoView: some View {
        Image(.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 160.0)
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
                Text(onboardingPage.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Text(onboardingPage.description)
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
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    Button{
                        goToNextTab()
                    } label: {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
            Group {
                if isFirstTab {
                    Button{
                        skipToLastTab()
                    } label: {
                        Text("Skip")
                            .frame(maxWidth: .infinity)
                    }
                } else {
                    Button{
                        goBackToPreviousTab()
                    } label: {
                        Text("Back")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .buttonStyle(.borderless)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
        }
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
    OnboardingView(
        isOnboardingCompleted: .constant(false)
    )
}
