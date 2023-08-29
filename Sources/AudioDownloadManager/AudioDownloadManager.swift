import Foundation

public class AudioDownloadManager: NSObject {
    
    var session:URLSession?
    var dataTask:URLSessionDownloadTask?
    typealias progressClosure = ((TaskResult) -> Void)
    var downloadAudioCallback: progressClosure!
    
    public func downloadAudio(with url: String) {
        if let audioUrl = URL(string: url) {
            let configuration = URLSessionConfiguration.default
            let manqueue = OperationQueue.main
            session = Foundation.URLSession(configuration: configuration, delegate:self, delegateQueue: manqueue)
            dataTask = session?.downloadTask(with: audioUrl)
            dataTask?.resume()
        } else {
            downloadAudioCallback(.failure("InValid URL"))
        }
    }

}

extension AudioDownloadManager: URLSessionDownloadDelegate {
   public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if progress < 1 && progress > 0.0 {
        downloadAudioCallback(.progress(progress))
        }
    }
    
 public func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        downloadAudioCallback(.downloaded(location))
      
    }
}
