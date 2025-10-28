//
//  PinMapView.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import SwiftUI
import Kingfisher
import TipKit

struct PinSelectionView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    @Binding var selectedPin: PinData?
    let pin: PinData
    let onSelected: () -> Void
    let selectPinTip: SelectPinTip = .init()
    var body: some View {
        PinOnMapView(
            latitude: pin.latitude,
            longitude: pin.longitude
        )
        .ignoresSafeArea()
        .overlay(alignment: .bottom) {
            pinInfoView
                .padding(16.0)
        }
        .navigationTitle(pin.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension PinSelectionView {
    var pinInfoView: some View {
        HStack(spacing: 16.0) {
            pinImageView(urlString: pin.photoUrl)
            VStack(alignment: .leading, spacing: 12.0) {
                Text(pin.name)
                    .font(.headline)
                selectButtonView
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16.0)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24.0))
    }
    func pinImageView(urlString: String?) -> some View {
        RoundedRectangle(cornerRadius: 8.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(width: 160.0, height: 120.0)
            .overlay {
                if let urlString {
                    KFImage(URL(string: urlString))
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(.imagePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60.0, height: 60.0)
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    var selectButtonView: some View {
        Button("Select") {
            selectedPin = pin
            onSelected()
        }
        .primaryFilledButtonStyle(controlSize: .regular)
        .popoverTip(selectPinTip, arrowEdge: .bottom)
    }
}

#Preview {
    PinSelectionView(
        selectedPin: .constant(nil),
        pin: .preview1,
        onSelected: {}
    )
}
