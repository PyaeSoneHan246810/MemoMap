//
//  MemoryVideoView.swift
//  MemoMap
//
//  Created by Dylan on 8/10/25.
//

import SwiftUI
import AVKit

struct MemoryVideoView: View {
    let url: URL
    @State private var player: AVPlayer? = nil
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player = AVPlayer(url: url)
            }
    }
}
