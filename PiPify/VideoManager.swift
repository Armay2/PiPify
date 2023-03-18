//
//  VideoManager.swift
//  PiPify
//
//  Created by Arnaud NOMMAY on 13/03/2023.
//

import Foundation
import AVKit

class VideoManager {
    
    //MARK: Singleton
    static let shared = VideoManager()
    
    func createVideoURL(from cgImage: CGImage, completion: @escaping (URL) -> Void) {
        let videoURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("imageVideo-\(UUID()).mp4"))
        
        guard let videoWriter = try? AVAssetWriter(outputURL: videoURL, fileType: .mp4) else {
            fatalError("Failed to create asset writer")
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: cgImage.width,
            AVVideoHeightKey: cgImage.height,
        ]
        
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)
        
        videoWriter.add(videoWriterInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let pixelBuffer = getPixelBuffer(from: cgImage)
        pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: .zero)
        
        videoWriterInput.markAsFinished()
        
        videoWriter.finishWriting {
            DispatchQueue.main.async {
                completion(videoURL)
            }
        }
    }
    

    func createVideo(from cgImage: CGImage, completion: @escaping (AVPlayer) -> Void) {
        let videoURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("imageVideo-\(UUID()).mp4"))
        
        guard let videoWriter = try? AVAssetWriter(outputURL: videoURL, fileType: .mp4) else {
            fatalError("Failed to create asset writer")
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: cgImage.width,
            AVVideoHeightKey: cgImage.height,
        ]
        
        let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: nil)
        
        videoWriter.add(videoWriterInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let pixelBuffer = getPixelBuffer(from: cgImage)
        pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: .zero)
        
        videoWriterInput.markAsFinished()
        
        videoWriter.finishWriting {
            DispatchQueue.main.async {
                let playerItem = AVPlayerItem(url: videoURL)
                let player = AVPlayer(playerItem: playerItem)
                completion(player)
            }
        }
    }
    
    private func getPixelBuffer(from cgImage: CGImage)  -> CVPixelBuffer {
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            cgImage.width,
            cgImage.height,
            kCVPixelFormatType_32ARGB,
            options as CFDictionary,
            &pixelBuffer)
        guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
            fatalError("Failed to create pixel buffer")
        }
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(buffer)!
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        let context = CGContext(
            data: pixelData,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        context!.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: cgImage.width, height: cgImage.height)))
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        return buffer
    }

}
