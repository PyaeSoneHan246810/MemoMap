//
//  View+Extension.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI

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
}
