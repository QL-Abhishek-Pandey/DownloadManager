//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI
import Combine
import AVKit

class PlayerManager: ObservableObject {
    
    //MARK: - Properties
    @Published var isPlay: Bool = false
    @Published var player: AVPlayer?
    
    
    //MARK: - playMedia
    func playMedia(with url: String) {
        if let urlPath = getMeidaPath(of: url) {
            let asset = AVURLAsset(url: urlPath, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer.init(playerItem: playerItem)
            player?.play()
            isPlay = true
        }
        
    }
    
    func pauseMedia() {
        isPlay = false
        player?.pause()
        
    }
    
    func resumeMedia() {
        player?.play()
        isPlay = true
    }
    
    
    //MARK: - getMeidaPath
    private func getMeidaPath(of url : String) -> URL?  {
        let docDir = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        guard let audioUrl = URL(string: url) else { return nil }
        let destinationUrl = docDir.appendingPathComponent(audioUrl.lastPathComponent)
        do {
            // List the contents of the directory
            let contents = try FileManager.default.contentsOfDirectory(at: docDir, includingPropertiesForKeys: nil, options: [])
            if let fileURL = contents.first(where: { $0 == destinationUrl }) {
                return fileURL
            }
        } catch {
            print("Error reading directory: \(error)")
        }
        return nil
    }
}
