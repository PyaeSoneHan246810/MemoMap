//
//  ChooseLocationView.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import SwiftUI
import TipKit

struct ChooseLocationView: View {
    @Binding var isPresented: Bool
    @Binding var selectedPin: PinData?
    @State private var viewModel: ChooseLocationViewModel = .init()
    let addPinTip: AddPinTip = .init()
    var body: some View {
        Group {
            switch viewModel.pinsDataState {
            case .initial, .loading:
                loadingProgressView
            case .success(_):
                pinsListView
            case .failure(let errorDescription):
                ErrorView(errorDescription: errorDescription)
            }
        }
        .navigationTitle("Choose saved location")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isAddPinSheetViewPresented) {
            addPinView
                .interactiveDismissDisabled()
        }
        .task {
            await viewModel.getPins()
        }
    }
}

private extension ChooseLocationView {
    var loadingProgressView: some View {
        ZStack {
            ProgressView().controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    @ViewBuilder
    var pinsListView: some View {
        if viewModel.filteredPins.isEmpty && viewModel.trimmedSearchText.isEmpty {
            EmptyContentView(
                image: .emptyData,
                title: "No Pins Yet",
                description: "You haven’t saved any locations yet."
            )
            .safeAreaInset(edge: .bottom) {
                addPinButtonView
            }
        } else {
            List {
                if viewModel.filteredPins.isEmpty {
                    emptySearchPinsView
                } else {
                    ForEach(viewModel.filteredPins) { pin in
                        NavigationLink {
                            pinMapView(
                                pin: pin
                            )
                        } label: {
                            pinItemView(pin: pin)
                        }
                        .navigationLinkIndicatorVisibility(.hidden)
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                prompt: Text("Search for saved locations")
            )
        }
    }
    var emptySearchPinsView: some View {
        EmptyContentView(
            image: .emptyData,
            title: "No Pins Found",
            description: "We couldn’t find any saved locations that match your search."
        )
    }
    func pinItemView(pin: PinData) -> some View {
        VStack(alignment: .leading, spacing: 8.0) {
            HStack(spacing: 4.0) {
                Image(systemName: "mappin.square")
                Text(pin.name)
                    .font(.headline)
            }
            Text(pin.description ?? "No description.")
                .font(.subheadline)
        }
    }
    var addPinButtonView: some View {
        Button("Add pin", systemImage: "plus") {
            viewModel.isAddPinSheetViewPresented = true
        }
        .primaryFilledButtonStyle(controlSize: .regular)
        .popoverTip(addPinTip, arrowEdge: .bottom)
    }
    func pinMapView(pin: PinData) -> some View {
        PinSelectionView(
            selectedPin: $selectedPin,
            pin: pin,
            onSelected: {
                isPresented = false
            }
        )
    }
    var addPinView: some View {
        NavigationStack {
            AddPinView(
                locationPhotoImage: $viewModel.locationPhotoImage,
                locationName: $viewModel.locationName,
                locationDescription: $viewModel.locationDescription,
                locationPlace: $viewModel.locationPlace,
                isSavePinInProgress: viewModel.isSavePinInProgress,
                savePinError: viewModel.savePinError,
                isSavePinAlertPresented: $viewModel.isSavePinAlertPresented,
                onSave: {
                    Task {
                        await viewModel.saveNewPin()
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        ChooseLocationView(
            isPresented: .constant(true),
            selectedPin: .constant(.preview1)
        )
    }
}
