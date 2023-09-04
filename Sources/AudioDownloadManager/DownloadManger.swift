
import Foundation
import Combine
import SwiftUI

//@available(macOS 10.15, *)
public class DownloadManger: ObservableObject {
    
    //MARK: - properties
    var playerManager = PlayerManager()
    private var downloadManager = DownloadTask()
    @Published public var taskResult: TaskResult = .progress(0.0)
    
    public init() {
        downloadManager.downloadAudioCallback = { [self] result in
            DispatchQueue.main.async {
                self.taskResult = result
            }
        }
    }
    
    //MARK: downloadAudio
    public func downloadMedia(with url: String) {
        downloadManager.downloadMedia(with: url)
    }
    
    //MARK: cancelDownload
    public func cancelDownload() {
        downloadManager.cancelMedia()
    }
    
    // MARK: - openAudioPlayer
    public func openAudioPlayer(with url: String) -> some View {
        playerManager.deinitPlayer()
        return AudioPlayerView(mediaUrl: url)
    }
    
    public func openVideoPlayer(with url: String) {
        playerManager.deinitPlayer()
        playerManager.playVideo(url: url)
    }
    
    //MARK: - isMediaExistInDir
    // check media is already download or not
    public func isMediaExistInDir(with url : String) -> Bool {
        if let _ =  playerManager.getMeidaPath(of: url) {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - removeMediaFromDir
    public func removeMediaFromDir(with url: String) {
        downloadManager.removeMedia(with: url)
    }
    
    
}
