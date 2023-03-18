//
//  ImageView.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import SwiftUI
import AVKit

struct MainView: View {
    @State var image: NSImage?
    @StateObject var model = VideoPlayerModel()

    var body: some View {
        VStack {
            PhotosSelector { image in
                guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                    print("no cg")
                    return
                }
                VideoManager.shared.createVideoURL(from: cgImage) { url in
                    self.model.reload(url: url)

                }
            }
            VideoPlayerView(playerView: model.playerView)
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
