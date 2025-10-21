//
//  View+Extension.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI
import SwiftUIIntrospect

extension View {
    func primaryFilledLargeButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .buttonSizing(.flexible)
            .controlSize(.large)
    }
    
    func secondaryFilledLargeButtonStyle() -> some View {
        self
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .buttonSizing(.flexible)
            .controlSize(.large)
    }
    
    func textLargeButtonStyle() -> some View {
        self
            .buttonStyle(.borderless)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
    }
    
    func primaryFilledButtonStyle(controlSize: ControlSize) -> some View {
        self
            .buttonStyle(.borderedProminent)
            .controlSize(controlSize)
    }
    
    func primaryFilledSmallButtonStyle() -> some View {
        self
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
    }
    
    func secondaryFilledSmallButtonStyle() -> some View {
        self
            .buttonStyle(.bordered)
            .controlSize(.small)
            .foregroundStyle(.primary)
    }
    
    func destructiveButtonStyle(controlSize: ControlSize) -> some View {
        self
            .buttonStyle(.bordered)
            .controlSize(controlSize)
            .tint(.red)
            .foregroundStyle(.red)
    }
    
    func disableBouncesVertically() -> some View {
        self
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
                scrollView.bouncesVertically = false
            }
    }
    
    func disableBouncesHorizontally() -> some View {
        self
            .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18, .v26)) { scrollView in
                scrollView.bouncesHorizontally = false
            }
    }
}
