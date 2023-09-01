//
//  File.swift
//  
//
//  Created by Abhishek Pandey on 30/08/23.
//

import SwiftUI
import Combine
import AVKit

var player: AVPlayer?
public class PlayerManager: ObservableObject {
    
    //MARK: - Properties
    @Published var isPlay: Bool = false
   // @Published var player: AVPlayer?
    @Published var totalDuration: String = "00:00"
    @Published var currentDuration: String = "00:00"
    
    
    //MARK: - playMedia
    public func playMedia(with url: String) {
        deinitPlayer()
        if let urlPath = getMeidaPath(of: url) {
            let asset = AVURLAsset(url: urlPath, options: nil)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer.init(playerItem: playerItem)
            let durationTime = getTime(with: asset.duration)
            totalDuration = "\(durationTime.0) : \(durationTime.1)"
            let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { time in
                let currentTime = self.getTime(with: time)
                self.currentDuration = "\(currentTime.0) : \(currentTime.1)"
            }
            
            player?.play()
            isPlay = true
        }
        
    }
    
   public func pauseMedia() {
        isPlay = false
        player?.pause()
        
    }
    
   public func resumeMedia() {
        player?.play()
        isPlay = true
    }
    
   public func deinitPlayer() {
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    //MARK: - getMeidaPath
    func getMeidaPath(of url : String) -> URL?  {
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
    
    //MARK: getTime
    func getTime(with time: CMTime) -> (Int, Int) {
        let totalSeconds = CMTimeGetSeconds(time)
        let minutes = Int(totalSeconds) / 60
        let seconds = Int(totalSeconds) % 60
        return(minutes, seconds)
    }
    
    //MARK:  Play Videp
    public func playVideo(url: String) {
        if let urlPath = getMeidaPath(of: url) {
            let videoAsset = AVURLAsset(url: urlPath, options: nil)
            let videoPlayerItem = AVPlayerItem(asset: videoAsset)
            let player = AVPlayer(playerItem: videoPlayerItem)
            let vc = AVPlayerViewController()
            vc.player = player
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topViewController = windowScene.windows.first?.rootViewController {
                topViewController.present(vc, animated: true) {
                    vc.player?.play()
                }
            }
        }
        
    }
}
