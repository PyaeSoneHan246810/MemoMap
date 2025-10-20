//
//  MemoryMediasView.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI
import Kingfisher

struct MemoryMediasView: View {
    let mediaUrlStrings: [String]
    private var medias: [Media] {
        let medias = mediaUrlStrings.map { mediaUrlString in
            let mediaType: MediaType = mediaUrlString.contains(".jpeg") ? .image : .video
            return Media(
                type: mediaType,
                urlString: mediaUrlString
            )
        }
        return medias
    }
    var body: some View {
        if medias.count == 1 {
            if let media = medias.first {
                singleMediaView(media)
            } else {
                EmptyView()
            }
        } else {
            multiMediaScrollView
        }
    }
}

private extension MemoryMediasView {
    func singleMediaView(_ media: Media) -> some View {
        Group {
            switch media.type {
            case .image:
                singleMediaImageView(url: media.urlString)
            case .video:
                if let url = URL(string: media.urlString) {
                    singleMediaVideoView(url: url)
                } else {
                    EmptyView()
                }
            }
        }
        .padding(.horizontal, 16.0)
    }
    func singleMediaImageView(url: String) -> some View {
        RoundedRectangle(cornerRadius: 12.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(height: 320.0)
            .overlay {
                KFImage(URL(string: url))
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    func singleMediaVideoView(url: URL) -> some View {
        MemoryVideoView(url: url)
            .frame(height: 320.0)
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    var multiMediaScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(medias) { media in
                    switch media.type {
                    case .image:
                        multiMediaImageView(url: media.urlString)
                    case .video:
                        if let url = URL(string: media.urlString) {
                            multiMediaVideoView(url: url)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .disableBouncesHorizontally()
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
    func multiMediaImageView(url: String) -> some View {
        RoundedRectangle(cornerRadius: 12.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(width: 320.0, height: 320.0)
            .overlay {
                KFImage(URL(string: url))
                    .resizable()
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    func multiMediaVideoView(url: URL) -> some View {
        MemoryVideoView(url: url)
        .frame(width: 320.0, height: 320.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
}

#Preview {
    MemoryMediasView(
        mediaUrlStrings: []
    )
}
