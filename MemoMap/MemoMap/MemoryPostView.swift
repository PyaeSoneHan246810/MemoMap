//
//  MemoryPostView.swift
//  MemoMap
//
//  Created by Dylan on 23/9/25.
//

import SwiftUI
import AVKit

struct MemoryPostView: View {
    let memoryPostInfo: MemoryPostInfo
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    @State private var currentSheetType: SheetType? = nil
    var body: some View {
        VStack(spacing: 12.0) {
            Spacer().frame(height: 16.0)
            Group {
                Group {
                    HStack(spacing: 12.0) {
                        profileInfoView
                        moreButtonView
                    }
                    memoryInfoView
                }
                .padding(.horizontal, 16.0)
                mediaView
                Group {
                    locationInfoView
                    userReactionsView
                }
                .padding(.horizontal, 16.0)
            }
            Spacer().frame(height: 16.0)
        }
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .sheet(item: $currentSheetType) { sheetType in
            Group {
                switch sheetType {
                case .viewOnMap:
                    viewOnMapSheetView
                case .hearts:
                    heartsSheetView
                case .comments:
                    commentsSheetView
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

extension MemoryPostView {
    struct MemoryPostInfo {
        let profilePhotoUrl: String
        let userDisplayName: String
        let ago: String
        let title: String
        let caption: String
        let tags: [String]
        let medias: [Media]
        let locationName: String
        let heartCount: Int
        let commentCount: Int
    }
    enum MediaType {
        case video
        case image
    }
    struct Media {
        var mediaType: MediaType
        var mediaUrl: String
    }
    static let previewMemoryPostInfo: MemoryPostInfo = .init(
        profilePhotoUrl: "",
        userDisplayName: "Display Name",
        ago: "2 hours ago",
        title: "Memory title",
        caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
        tags: ["Tag 1", "Tag 2"],
        medias: [
            .init(mediaType: .image, mediaUrl: ""),
            .init(mediaType: .video, mediaUrl: "https://assets.mixkit.co/9v5r5knro4wjxtve7oo4hjizb6fw")
        ],
        locationName: "Location name",
        heartCount: 12,
        commentCount: 4
    )
    enum SheetType: String, Identifiable {
        case viewOnMap = "View on map"
        case hearts = "Hearts"
        case comments = "Comments"
        var id: String {
            self.rawValue
        }
    }
}

private extension MemoryPostView {
    var profileInfoView: some View {
        HStack(spacing: 12.0) {
            profilePhotoView
            VStack(alignment: .leading, spacing: 0.0) {
                displayNameView
                Text(memoryPostInfo.ago)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var profilePhotoView: some View {
        Image(.profilePlaceholder)
            .resizable()
            .scaledToFit()
            .frame(width: 52.0, height: 52.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .onTapGesture {
                navigateToUserProfile()
            }
    }
    var displayNameView: some View {
        Text(memoryPostInfo.userDisplayName)
            .font(.headline)
            .onTapGesture {
                navigateToUserProfile()
            }
    }
    var moreButtonView: some View {
        Button {
            
        } label: {
            Image(systemName: "ellipsis")
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.circle)
        .foregroundStyle(.primary)
        .controlSize(.large)
    }
    var memoryInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(memoryPostInfo.title)
                .font(.headline)
            Text(memoryPostInfo.caption)
                .font(.subheadline)
            HStack(spacing: 4.0) {
                ForEach(memoryPostInfo.tags, id: \.self) { tag in
                    TagView(text: tag)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var mediaView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(memoryPostInfo.medias, id: \.mediaUrl) { media in
                    let url = media.mediaUrl
                    switch media.mediaType {
                    case .image:
                        photoView(url: url)
                    case .video:
                        videoView(url: url)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 16.0)
    }
    func photoView(url: String) -> some View {
        RoundedRectangle(cornerRadius: 12.0)
            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            .frame(width: 320.0, height: 320.0)
            .overlay {
                
            }
    }
    func videoView(url: String) -> some View {
        VideoPlayer(
            player: AVPlayer(url: URL(string: url)!)
        )
        .frame(width: 320.0, height: 320.0)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
    }
    var locationInfoView: some View {
        HStack {
            Text(memoryPostInfo.locationName)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Button("View on map", systemImage: "map") {
                currentSheetType = .viewOnMap
            }
            .buttonStyle(.bordered)
            .foregroundStyle(.primary)
            .controlSize(.small)
        }
    }
    var userReactionsView: some View {
        HStack(spacing: 12.0) {
            heartButtonView
            commentButtonView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var heartButtonView: some View {
        HStack(spacing: 4.0) {
            Button {
                
            } label: {
                Label(memoryPostInfo.heartCount.description, systemImage: "heart")
                    .labelStyle(.iconOnly)
            }
            .controlSize(.large)
            .tint(.primary)
            Label(memoryPostInfo.heartCount.description, systemImage: "heart")
                .labelStyle(.titleOnly)
                .onTapGesture {
                    currentSheetType = .hearts
                }
        }
    }
    var commentButtonView: some View {
        Button {
            currentSheetType = .comments
        } label: {
            Label(memoryPostInfo.commentCount.description, systemImage: "message")
                .labelIconToTitleSpacing(4.0)
        }
        .controlSize(.large)
        .tint(.primary)
    }
    var viewOnMapSheetView: some View {
        NavigationStack {
            ViewOnMapView()
        }
    }
    var heartsSheetView: some View {
        Text("Hearts")
    }
    var commentsSheetView: some View {
        NavigationStack {
            CommentsView()
        }
    }
}

private extension MemoryPostView {
    func navigateToUserProfile() {
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: "userId")
        self.userProfileScreenModel = userProfileScreenModel
    }
}

#Preview {
    MemoryPostView(
        memoryPostInfo: MemoryPostView.previewMemoryPostInfo,
        userProfileScreenModel: .constant(nil)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
