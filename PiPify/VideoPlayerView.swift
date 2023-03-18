//
//  RecorderPlayerView.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import Foundation
import SwiftUI
import AVKit

struct VideoPlayerView: NSViewRepresentable {
    typealias NSViewType = AVPlayerView
    
    var playerView: AVPlayerView
    
    func makeNSView(context: Context) -> AVPlayerView {
        playerView.allowsPictureInPicturePlayback = true
        return playerView
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {}
    
    // new code
    
}
