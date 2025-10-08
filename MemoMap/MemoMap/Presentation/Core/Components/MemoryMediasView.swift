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
            let mediaType: MemoryMediasView.MediaType = mediaUrlString.contains(".jpeg") ? .image : .video
            return MemoryMediasView.Media(
                type: mediaType,
                urlString: mediaUrlString
            )
        }
        return medias
    }
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(medias) { media in
                    switch media.type {
                    case .image:
                        photoView(url: media.urlString)
                    case .video:
                        if let url = URL(string: media.urlString) {
                            videoView(url: url)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
}

extension MemoryMediasView {
    enum MediaType {
        case video
        case image
    }
    struct Media: Identifiable {
        var type: MediaType
        var urlString: String
        var id: String {
            urlString
        }
    }
}

private extension MemoryMediasView {
    func photoView(url: String) -> some View {
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
    func videoView(url: URL) -> some View {
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
