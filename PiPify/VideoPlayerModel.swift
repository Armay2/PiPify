//
//  VideoPlayerModel.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import Foundation
import AVKit

class VideoPlayerModel: ObservableObject {
    @Published var playerView: AVPlayerView

    init() {
        self.playerView = AVPlayerView()
        self.playerView.player = AVPlayer()
    }

    func reload(url: URL) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        self.playerView.player?.replaceCurrentItem(with: item)
    }
}
