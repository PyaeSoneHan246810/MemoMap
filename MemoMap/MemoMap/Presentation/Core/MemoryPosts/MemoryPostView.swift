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
    let memory: MemoryData
    @Binding var userProfileScreenModel: UserProfileScreenModel?
    @State private var viewModel: MemoryPostViewModel = .init()
    private var memoryId: String {
        memory.id
    }
    private var userId: String {
        memory.ownerId
    }
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
        .sheet(item: $viewModel.currentSheetType) { sheetType in
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
        .onAppear {
            viewModel.listenHeartsCount(memoryId: memoryId)
            viewModel.listenCommentsCount(memoryId: memoryId)
            Task {
                await viewModel.checkIsHeartGiven(
                    memoryId: memoryId
                )
            }
            Task {
                await viewModel.getUserProfile(userId: userId)
            }
        }
    }
}

private extension MemoryPostView {
    var profileInfoView: some View {
        HStack(spacing: 12.0) {
            profilePhotoView
            VStack(alignment: .leading, spacing: 0.0) {
                displayNameView
                Text(memory.createdAt.formatted())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var profilePhotoView: some View {
        Group {
            let userProfilePhotoUrl = viewModel.userProfile?.profilePhotoUrl
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
        let userDisplayName = viewModel.userProfile?.displayname
        return Text(userDisplayName ?? "Placeholder")
            .font(.headline)
            .onTapGesture {
                navigateToUserProfile()
            }
            .redacted(reason: userDisplayName == nil ? .placeholder : [])
    }
    var memoryInfoView: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(memory.title)
                .font(.headline)
            if let memoryDescription = memory.description {
                Text(memoryDescription)
                    .font(.subheadline)
            }
            MemoryTagsView(
                tags: memory.tags
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var memoryMediasView: some View {
        MemoryMediasView(
            mediaUrlStrings: memory.media
        )
    }
    var locationInfoView: some View {
        HStack {
            Text(memory.locationName)
                .font(.subheadline)
                .fontWeight(.medium)
            Spacer()
            Button("View on map", systemImage: "map") {
                viewModel.currentSheetType = .viewOnMap
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
                Task {
                    await toggleHeart()
                }
            } label: {
                Label("Heart", systemImage: viewModel.isHeartGiven ? "heart.fill" : "heart")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(viewModel.isHeartGiven ? .pink : .primary)
            }
            .controlSize(.large)
            .tint(.primary)
            Label(viewModel.heartsCount.description, systemImage: "heart")
                .labelStyle(.titleOnly)
                .onTapGesture {
                    viewModel.currentSheetType = .hearts
                }
        }
    }
    var commentButtonView: some View {
        Button {
            viewModel.currentSheetType = .comments
        } label: {
            Label(viewModel.commentsCount.description, systemImage: "message")
                .labelIconToTitleSpacing(4.0)
        }
        .controlSize(.large)
        .tint(.primary)
    }
    var viewOnMapSheetView: some View {
        NavigationStack {
            ViewOnMapView(
                locationName: memory.locationName,
                latitude: memory.latitude,
                longitude: memory.longitude
            )
        }
    }
    var heartsSheetView: some View {
        NavigationStack {
            HeartsView(
                memoryId: memory.id
            )
        }
    }
    var commentsSheetView: some View {
        NavigationStack {
            CommentsView(
                memoryId: memory.id
            )
        }
    }
}

private extension MemoryPostView {
    func navigateToUserProfile() {
        let userProfileScreenModel: UserProfileScreenModel = .init(userId: "userId")
        self.userProfileScreenModel = userProfileScreenModel
    }
    
    func toggleHeart() async {
        await viewModel.toggleHeart(
            memoryId: memoryId
        )
    }
}

#Preview {
    MemoryPostView(
        memory: MemoryData.preview1,
        userProfileScreenModel: .constant(nil)
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemFill))
}
