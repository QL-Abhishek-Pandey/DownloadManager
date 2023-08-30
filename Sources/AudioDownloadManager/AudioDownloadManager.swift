
import Foundation
import Combine

//@available(macOS 10.15, *)
public class AudioDownloadManager: ObservableObject {
    var player = PlayerManager()
    private var downloadManager = AudioDownloadTask()
    private var cancellables = Set<AnyCancellable>()
    
    @Published public var taskResult: TaskResult = .progress(0.0)
    
    public init() {
        downloadManager.downloadAudioCallback = { [self] result in
            self.taskResult = result
        }
    }
    
    public func downloadAudio(with url: String) {
        downloadManager.downloadAudio(with: url)
    }
    
    public func cancelDownload() {
        downloadManager.cancelMedia()
    }
    
    public func playMedia(with url: String) {
        player.playMedia(with: url)
    }
    
}
