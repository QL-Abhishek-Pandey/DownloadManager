
import Foundation
import Combine

//@available(macOS 10.15, *)
public class AudioDownloadManager: ObservableObject {
    private var downloadManager = AudioDownloadTask()
    private var cancellables = Set<AnyCancellable>()

    @Published public var taskResult: TaskResult = .progress(0.0)

    public init() {
        downloadManager.downloadAudioCallback = { [weak self] result in
            self?.taskResult = result
        }
    }

    public func downloadAudio(with url: String) {
        downloadManager.downloadAudio(with: url)
    }
}
