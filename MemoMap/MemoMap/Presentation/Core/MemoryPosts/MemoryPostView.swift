//
//  MemoryPostView.swift
//  MemoMap
//
//  Created by Dylan on 23/9/25.
//

import SwiftUI
import AVKit
import Kingfisher

struct MemoryPostView: View {
    let memoryPostInfo: MemoryPostInfo
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    @State private var currentSheetType: SheetType? = nil
    var body: some View {
        VStack(spacing: 12.0) {
            Group {
                HStack(spacing: 12.0) {
                    profileInfoView
                    MoreButtonView {
                        
                    }
                }
                memoryInfoView
            }
            .padding(.horizontal, 16.0)
            memoryMediasView
            Group {
                locationInfoView
                userReactionsView
            }
            .padding(.horizontal, 16.0)
        }
        .padding(.vertical, 16.0)
        .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 12.0))
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
        let userProfile: UserProfileData?
        let memory: MemoryData
    }
    static let previewMemoryPostInfo: MemoryPostInfo = .init(
        userProfile: UserProfileData.preview1,
        memory: MemoryData.preview1,
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
                Text(memoryPostInfo.memory.createdAt.formatted())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var profilePhotoView: some View {
        Group {
            let userProfilePhotoUrl = memoryPostInfo.userProfile?.profilePhotoUrl
            if let userProfilePhotoUrl {
                Circle()
                    .frame(width: 52.0, height: 52.0)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                    .overlay {
                        KFImage(URL(string: userProfilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                    }
                    .clipShape(.circle)
            } else {
                Image(.profilePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 52.0, height: 52.0)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
            }
        }
        .onTapGesture {
            navigateToUserProfile()
        }
    }
    var displayNameView: some View {
        let userDisplayName = memoryPostInfo.userProfile?.displayname
        return Text(userDisplayName ?? "Placeholder")
            .font(.headline)
            .onTapGesture {
                navigateToUserProfile()
            }
            .redacted(reason: userDisplayName == nil ? .placeholder : [])
    }
    var memoryInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(memoryPostInfo.memory.title)
                .font(.headline)
            if let memoryDescription = memoryPostInfo.memory.description {
                Text(memoryDescription)
                    .font(.subheadline)
            }
            MemoryTagsView(
                tags: memoryPostInfo.memory.tags
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var memoryMediasView: some View {
        MemoryMediasView(
            mediaUrlStrings: memoryPostInfo.memory.media
        )
    }
    var locationInfoView: some View {
        HStack {
            Text(memoryPostInfo.memory.locationName)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Button("View on map", systemImage: "map") {
                currentSheetType = .viewOnMap
            }
            .secondaryFilledSmallButtonStyle()
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
                Label("Comment", systemImage: "heart")
                    .labelStyle(.iconOnly)
            }
            .controlSize(.large)
            .tint(.primary)
            Label(memoryPostInfo.memory.heartsCount.description, systemImage: "heart")
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
            Label(memoryPostInfo.memory.commentsCount.description, systemImage: "message")
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
        NavigationStack {
            HeartsView()
        }
    }
    var commentsSheetView: some View {
        NavigationStack {
            CommentsView(
                memoryId: memoryPostInfo.memory.id
            )
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
